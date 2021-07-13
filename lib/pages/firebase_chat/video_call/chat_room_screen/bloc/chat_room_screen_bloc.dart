import 'dart:async';
import 'package:aero_meet/utils/settings.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_room_screen_event.dart';

part 'chat_room_screen_state.dart';

class ChatRoomScreenBloc extends Bloc<ChatRoomScreenEvent, ChatRoomScreenState> {
  ChatRoomScreenBloc(String channel) : super(ChatRoomScreenState.empty()) {
    add(InitializeChatRoomScreen(channel: channel));
  }

  // @override
  // ChatRoomScreenState get initialState => ChatRoomScreenState.empty();

  @override
  Stream<ChatRoomScreenState> mapEventToState(
    ChatRoomScreenEvent event,
  ) async* {
    if (event is InitializeChatRoomScreen) {
      yield* _mapInitializeChatRoomScreenToState(event);
    } else if (event is AgoraEngineError) {
      yield* _mapAgoraEngineErrorToState(event);
    } else if (event is AgoraEngineJoinChannelSuccess) {
      yield* _mapAgoraEngineJoinChannelSuccessToState(event);
    } else if (event is AgoraEngineLeaveChannel) {
      yield* _mapAgoraEngineLeaveChannelToState(event);
    } else if (event is AgoraEngineFirstRemoteVideoFrame) {
      yield* _mapAgoraEngineFirstRemoteVideoFrameToState(event);
    } else if (event is AgoraEngineUserOffline) {
      yield* _mapAgoraEngineUserOfflineToState(event);
    } else if (event is AgoraEngineUserJoined) {
      yield* _mapAgoraEngineUserJoinedToState(event);
    } else if (event is ToggleMute) {
      yield* _mapToggleMuteToState(event);
    }
  }

  RtcEngine _engine;

  Stream<ChatRoomScreenState> _mapInitializeChatRoomScreenToState(
      InitializeChatRoomScreen event) async* {
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
    // video settings
    VideoEncoderConfiguration config = VideoEncoderConfiguration();
    config.orientationMode = VideoOutputOrientationMode.FixedPortrait;
    config.degradationPrefer = DegradationPreference.MaintainFramerate;
    config.frameRate = VideoFrameRate.Fps30;
    config.minFrameRate = VideoFrameRate.Fps15;
    config.dimensions = VideoDimensions(320, 180);
    config.bitrate = 1;
    config.minBitrate = 100;

    await _engine.enableVideo();
    await _engine.startPreview();
    // TODO: stream higher quality video
    await _engine.setChannelProfile(ChannelProfile.Communication);
    await _engine.setVideoEncoderConfiguration(config);
    // TODO: ensure android device plays audio...
    await _engine.setAudioProfile(AudioProfile.SpeechStandard, AudioScenario.Default);
    await _engine.setDefaultAudioRoutetoSpeakerphone(true);
    await _engine.setEnableSpeakerphone(true);
    await _engine.adjustPlaybackSignalVolume(400);
    await _engine.adjustRecordingSignalVolume(400);
    await _engine.adjustAudioMixingVolume(100);

    await _engine.joinChannel(null, event.channel, null, 0);
    yield state.copyWith(loading: false);
  }

  Stream<ChatRoomScreenState> _mapAgoraEngineErrorToState(
      AgoraEngineError event) async* {
    List<String> updatedInfoStrings = state.infoStrings;
    final info = 'onError: ${event.code}';
    updatedInfoStrings.add(info);
    yield state.copyWith(
      infoStrings: updatedInfoStrings,
    );
  }

  Stream<ChatRoomScreenState> _mapAgoraEngineLeaveChannelToState(
      AgoraEngineLeaveChannel event) async* {
    List<String> updatedInfoStrings = state.infoStrings;
    List<int> updatedUsers = state.users;
    updatedInfoStrings..add('onLeaveChannel');
    updatedUsers.clear();
    yield state.copyWith(
      infoStrings: updatedInfoStrings,
      users: updatedUsers,
    );
  }

  Stream<ChatRoomScreenState> _mapAgoraEngineFirstRemoteVideoFrameToState(
      AgoraEngineFirstRemoteVideoFrame event) async* {
    List<String> updatedInfoStrings = state.infoStrings;
    final info = 'firstRemoteVideo: $event.uid ${event.width}x $event.height';
    updatedInfoStrings.add(info);
    yield state.copyWith(
      infoStrings: updatedInfoStrings,
    );
  }

  Stream<ChatRoomScreenState> _mapAgoraEngineUserOfflineToState(
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

  Stream<ChatRoomScreenState> _mapAgoraEngineUserJoinedToState(
      AgoraEngineUserJoined event) async* {
    final info = 'userJoined: $event.uid';
    List<String> updatedInfoStrings = state.infoStrings;
    List<int> updatedUsers = state.users;
    updatedInfoStrings.add(info);
    updatedUsers.add(event.uid);
    yield state.copyWith(
      users: updatedUsers,
      infoStrings: updatedInfoStrings,
    );
  }

  Stream<ChatRoomScreenState> _mapAgoraEngineJoinChannelSuccessToState(
      AgoraEngineJoinChannelSuccess event) async* {
    List<String> updatedInfoStrings = state.infoStrings;
    final info = 'onJoinChannel: ${event.channel}, uid: ${event.uid}';
    updatedInfoStrings.add(info);
    yield state.copyWith(
      infoStrings: updatedInfoStrings,
    );
  }

  Stream<ChatRoomScreenState> _mapToggleMuteToState(ToggleMute event) async* {
    await _engine.muteLocalAudioStream(!state.muted);
    yield state.copyWith(
      muted: !state.muted,
    );
  }

  Stream<ChatRoomScreenState> _mapSwitchCameraToState(
      SwitchCamera event) async* {
    await _engine.switchCamera();
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
  }

  /// Add agora event handlers
  _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        add(AgoraEngineError(code));
      },
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        add(AgoraEngineJoinChannelSuccess(
          channel: channel,
          uid: uid,
          elapsed: elapsed,
        ));
      },
      leaveChannel: (_) {
        add(AgoraEngineLeaveChannel());
      },
      userJoined: (int uid, int elapsed) {
        add(AgoraEngineUserJoined(
          uid: uid,
          elapsed: elapsed,
        ));
      },
      userOffline: (int uid, reason) {
        add(AgoraEngineUserOffline(uid: uid, reason: reason.index));
      },
      firstRemoteVideoFrame: (
          int uid,
          int width,
          int height,
          int elapsed,
          ) {
        add(AgoraEngineFirstRemoteVideoFrame(
          uid: uid,
          width: width,
          height: height,
          elapsed: elapsed,
        ));
      }
    ));
  }

  @override
  Future<void> close() {
    _engine.leaveChannel();
    _engine.destroy();
    return super.close();
  }
}
