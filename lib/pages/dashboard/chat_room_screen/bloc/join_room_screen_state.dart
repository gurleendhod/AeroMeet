part of 'join_room_screen_bloc.dart';

@immutable
class JoinRoomScreenState {
  final bool loading;
  final String channelName;
  final List<String> infoStrings;
  final List<int> users;
  final bool muted;

  JoinRoomScreenState({
    @required this.loading,
    @required this.channelName,
    @required this.infoStrings,
    @required this.users,
    @required this.muted,
  });

  JoinRoomScreenState copyWith({
    bool loading,
    String channelName,
    List<String> infoStrings,
    List<int> users,
    bool muted,
  }){
    return JoinRoomScreenState(
      loading: loading ?? this.loading,
      channelName: channelName ?? this.channelName,
      infoStrings: infoStrings ?? this.infoStrings,
      users: users ?? this.users,
      muted: muted ?? this.muted,
    );
  }

  factory JoinRoomScreenState.empty(){
    return JoinRoomScreenState(
      loading: true,
      channelName: '123',
      infoStrings: [],
      users: [],
      muted: false,
    );
  }
}

