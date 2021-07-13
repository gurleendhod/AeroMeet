part of 'chat_room_screen_audio_bloc.dart';

@immutable
abstract class ChatRoomAudioScreenEvent {}

class InitializeChatRoomAudioScreen extends ChatRoomAudioScreenEvent {
  final channel;

  InitializeChatRoomAudioScreen({@required this.channel});
}
class AgoraEngineError extends ChatRoomAudioScreenEvent {
  final dynamic code;
  AgoraEngineError(this.code);
}
class AgoraEngineJoinChannelSuccess extends ChatRoomAudioScreenEvent {
  final String channel;
  final int uid;
  final int elapsed;

  AgoraEngineJoinChannelSuccess({
    @required this.channel,
    @required this.uid,
    @required this.elapsed,
  });
}

class AgoraEngineLeaveChannel extends ChatRoomAudioScreenEvent {}

class AgoraEngineUserOffline extends ChatRoomAudioScreenEvent {
  final int uid;
  final int reason;
  AgoraEngineUserOffline({
    @required this.uid,
    @required this.reason,
  });
}
class AgoraEngineUserJoined extends ChatRoomAudioScreenEvent {
  final int uid;
  final int elapsed;
  AgoraEngineUserJoined({
    @required this.uid,
    @required this.elapsed,
  });
}
class SwitchMicroPhone extends ChatRoomAudioScreenEvent {

}
class SwitchSpeakerPhone extends ChatRoomAudioScreenEvent {

}