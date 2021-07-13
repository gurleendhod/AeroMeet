import 'dart:async';
import 'package:aero_meet/utils/settings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'chat_room_screen_audio_event.dart';

part 'chat_room_screen_audio_state.dart';

class ChatRoomAudioScreenBloc
    extends Bloc<ChatRoomAudioScreenEvent, ChatRoomAudioScreenState> {
  ChatRoomAudioScreenBloc(String channel)
      : super(ChatRoomAudioScreenState.empty()) {
    add(InitializeChatRoomAudioScreen(channel: channel));
  }

  // @override
  // ChatRoomScreenState get initialState => ChatRoomScreenState.empty();

  @override
  Stream<ChatRoomAudioScreenState> mapEventToState(
    ChatRoomAudioScreenEvent event,
  ) async* {
    if (event is InitializeChatRoomAudioScreen) {
      yield* _mapInitializeChatRoomScreenToState(event);
    } else if (event is AgoraEngineError) {
      yield* _mapAgoraEngineErrorToState(event);
    } else if (event is AgoraEngineJoinChannelSuccess) {
      yield* _mapAgoraEngineJoinChannelSuccessToState(event);
    } else if (event is AgoraEngineLeaveChannel) {
      yield* _mapAgoraEngineLeaveChannelToState(event);
    } else if (event is AgoraEngineUserOffline) {
      yield* _mapAgoraEngineUserOfflineToState(event);
    } else if (event is AgoraEngineUserJoined) {
      yield* _mapAgoraEngineUserJoinedToState(event);
    } else if (event is SwitchMicroPhone) {
      yield* _mapSwitchMicroPhoneToState(event);
    } else if (event is SwitchSpeakerPhone) {
      yield* _mapSwitchSpeakerPhoneToState(event);
    }
  }

  RtcEngine _engine;

  Stream<ChatRoomAudioScreenState> _mapInitializeChatRoomScreenToState(
      InitializeChatRoomAudioScreen event) async* {

    _handleCameraAndMic();

    if (APP_ID.isEmpty) {
      List<String> updatedInfoStrings = state.infoStrings;
      updatedInfoStrings.add(
        'APP_ID missing, please provide your APP_ID in settings.dart',
      );
      updatedInfoStrings.add('Agora Engine is not starting');
      yield state.copyWith(
        infoStrings: updatedInfoStrings,
      );
    }
    await _initAgoraRtcEngine();

    _addAgoraEventHandlers();

    await _engine?.joinChannel(null, event.channel, null, 0)?.catchError((err) {
      print('error ${err.toString()}');
    });
    yield state.copyWith(loading: false);
  }

  Stream<ChatRoomAudioScreenState> _mapAgoraEngineErrorToState(
      AgoraEngineError event) async* {
    List<String> updatedInfoStrings = state.infoStrings;
    final info = 'onError: ${event.code}';
    updatedInfoStrings.add(info);
    yield state.copyWith(
      infoStrings: updatedInfoStrings,
    );
  }

  Stream<ChatRoomAudioScreenState> _mapAgoraEngineLeaveChannelToState(
      AgoraEngineLeaveChannel event) async* {
    List<String> updatedInfoStrings = state.infoStrings;
    List<int> updatedUsers = state.users;
    updatedInfoStrings..add('onLeaveChannel');
    updatedUsers.clear();
    await _engine.leaveChannel();
    yield state.copyWith(
      infoStrings: updatedInfoStrings,
      users: updatedUsers,
    );
  }

  Stream<ChatRoomAudioScreenState> _mapAgoraEngineUserOfflineToState(
      AgoraEngineUserOffline event) async* {
    final info = 'userOffline: $event.uid';
    List<String> updatedInfoStrings = state.infoStrings;
    List<int> updatedUsers = state.users;
    updatedInfoStrings.add(info);
    updatedUsers.remove(event.uid);
    yield state.copyWith(
      users: updatedUsers,
      infoStrings: updatedInfoStrings,
    );
  }

  Stream<ChatRoomAudioScreenState> _mapAgoraEngineUserJoinedToState(
      AgoraEngineUserJoined event) async* {
    final info = 'userJoined: ${event.uid}';
    List<String> updatedInfoStrings = state.infoStrings;
    List<int> updatedUsers = state.users;
    updatedInfoStrings.add(info);
    updatedUsers.add(event.uid);
    yield state.copyWith(
      users: updatedUsers,
      infoStrings: updatedInfoStrings,
    );
  }

  Stream<ChatRoomAudioScreenState> _mapAgoraEngineJoinChannelSuccessToState(
      AgoraEngineJoinChannelSuccess event) async* {
    List<String> updatedInfoStrings = state.infoStrings;
    final info = 'onJoinChannel: ${event.channel}, uid: ${event.uid}';
    updatedInfoStrings.add(info);
    yield state.copyWith(
      infoStrings: updatedInfoStrings,
    );
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);

    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      add(AgoraEngineError(code));
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      add(AgoraEngineJoinChannelSuccess(
        channel: channel,
        uid: uid,
        elapsed: elapsed,
      ));
    }, leaveChannel: (_) {
      add(AgoraEngineLeaveChannel());
    }, userJoined: (int uid, int elapsed) {
      add(AgoraEngineUserJoined(
        uid: uid,
        elapsed: elapsed,
      ));
    }, userOffline: (int uid, reason) {
      add(AgoraEngineUserOffline(uid: uid, reason: reason.index));
    }));
  }

  Stream<ChatRoomAudioScreenState> _mapSwitchMicroPhoneToState(
      SwitchMicroPhone event) async* {
    await _engine.muteLocalAudioStream(!state.openMicrophone);
    yield state.copyWith(openMicrophone: !state.openMicrophone);
  }

  Stream<ChatRoomAudioScreenState> _mapSwitchSpeakerPhoneToState(
      SwitchSpeakerPhone event) async* {
    await _engine.setEnableSpeakerphone(!state.openSpeaker);
    yield state.copyWith(speakerEnabled: !state.openSpeaker);
  }

  @override
  Future<void> close() {
    _engine.leaveChannel();
    _engine.destroy();
    return super.close();
  }

  Future<void> _handleCameraAndMic() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.microphone].request();
    if (!status[Permission.microphone].isGranted) {
      await Permission.microphone.request();
    }
  }
}
