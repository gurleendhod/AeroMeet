part of 'join_room_screen_bloc.dart';

@immutable
abstract class JoinRoomScreenEvent {}

class InitializeChatRoomScreen extends JoinRoomScreenEvent {
  final channel;

  InitializeChatRoomScreen({@required this.channel});
}

class AgoraEngineError extends JoinRoomScreenEvent {
  final dynamic code;
  AgoraEngineError(this.code);
}

class AgoraEngineJoinChannelSuccess extends JoinRoomScreenEvent {
  final String channel;
  final int uid;
  final int elapsed;

  AgoraEngineJoinChannelSuccess({
    @required this.channel,
    @required this.uid,
    @required this.elapsed,
  });
}

class AgoraEngineLeaveChannel extends JoinRoomScreenEvent {}

class AgoraEngineFirstRemoteVideoFrame extends JoinRoomScreenEvent {
  final int uid;
  final int width;
  final int height;
  final int elapsed;
  AgoraEngineFirstRemoteVideoFrame({
    @required this.uid,
    @required this.width,
    @required this.height,
    @required this.elapsed,
  });
}

class AgoraEngineUserOffline extends JoinRoomScreenEvent {
  final int uid;
  final int reason;
  AgoraEngineUserOffline({
    @required this.uid,
    @required this.reason,
  });
}

class AgoraEngineUserJoined extends JoinRoomScreenEvent {
  final int uid;
  final int elapsed;
  AgoraEngineUserJoined({
    @required this.uid,
    @required this.elapsed,
  });
}

class ToggleMute extends JoinRoomScreenEvent {}

class SwitchCamera extends JoinRoomScreenEvent {}
