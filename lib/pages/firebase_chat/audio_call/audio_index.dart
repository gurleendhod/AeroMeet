import 'dart:async';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/chat_room_screen_audio_bloc.dart';
import 'chat_room_audio_screen.dart';

class AudioIndexPage extends StatefulWidget {

  final channel;
  final ChatProfile friend;
  final currentUserUID;

  AudioIndexPage({this.channel,this.friend,this.currentUserUID});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<AudioIndexPage> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //onJoin();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatRoomAudioScreenBloc>(
      create: (BuildContext c) => ChatRoomAudioScreenBloc(widget.channel),
      child: ChatRoomAudioScreen(friend: widget.friend,
        currentUserUid: widget.currentUserUID,channel: widget.channel,),
    );
  }

  Future<void> onJoin() async {
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BlocProvider<ChatRoomAudioScreenBloc>(
                create: (BuildContext c) => ChatRoomAudioScreenBloc(widget.channel),
                child: ChatRoomAudioScreen(friend: widget.friend,
                  currentUserUid: widget.currentUserUID,channel: widget.channel,),
              )
      ),
    );
  }
}
