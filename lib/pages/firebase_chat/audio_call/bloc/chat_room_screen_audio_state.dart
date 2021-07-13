part of 'chat_room_screen_audio_bloc.dart';

@immutable
class ChatRoomAudioScreenState {
  final bool loading;
  final String channelName;
  final List<String> infoStrings;
  final List<int> users;
  final bool openSpeaker;
  final bool openMicrophone;

  ChatRoomAudioScreenState({
    @required this.loading,
    @required this.channelName,
    @required this.infoStrings,
    @required this.users,
    @required this.openSpeaker,
    @required this.openMicrophone,
  });

  ChatRoomAudioScreenState copyWith({
    bool loading,
    String channelName,
    List<String> infoStrings,
    List<int> users,
    bool speakerEnabled,
    bool openMicrophone
  }){
    return ChatRoomAudioScreenState(
      loading: loading ?? this.loading,
      channelName: channelName ?? this.channelName,
      infoStrings: infoStrings ?? this.infoStrings,
      users: users ?? this.users,
      openSpeaker: speakerEnabled ?? this.openSpeaker,
      openMicrophone: openMicrophone ?? this.openMicrophone,
    );
  }

  factory ChatRoomAudioScreenState.empty(){
    return ChatRoomAudioScreenState(
      loading: true,
      channelName: '123',
      infoStrings: [],
      users: [],
      openSpeaker: false,
      openMicrophone: false,
    );
  }
}

