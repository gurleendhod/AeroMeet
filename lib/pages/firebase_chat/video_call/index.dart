import 'dart:async';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'chat_room_screen/bloc/chat_room_screen_bloc.dart';
import 'chat_room_screen/chat_room_screen.dart';

class IndexPage extends StatefulWidget {

  final channel;
  final ChatProfile friend;
  final currentUserUID;

  IndexPage({this.channel,this.friend,this.currentUserUID});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();


  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    onJoin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
//              Row(
//                children: <Widget>[
//                  Expanded(
//                      child: TextField(
//                    controller: _channelController,
//                    decoration: InputDecoration(
//                      errorText:
//                          _validateError ? 'Channel name is mandatory' : null,
//                      border: UnderlineInputBorder(
//                        borderSide: BorderSide(width: 1),
//                      ),
//                      hintText: 'Channel name',
//                    ),
//                  ))
//                ],
//              ),
//              Padding(
//                padding: const EdgeInsets.symmetric(vertical: 20),
//                child: Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: RaisedButton(
//                        onPressed: onJoin,
//                        child: Text('Join'),
//                        color: Colors.blueAccent,
//                        textColor: Colors.white,
//                      ),
//                    )
//                  ],
//                ),
//              ),
              Container(
                child: Text(
                  'connecting..',
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BlocProvider<ChatRoomScreenBloc>(
                create: (BuildContext c) => ChatRoomScreenBloc(widget.channel),
                child: ChatRoomScreen(friend: widget.friend,
                  currentUserUid: widget.currentUserUID,),
              )
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {

    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if(!status[Permission.microphone].isGranted){
      await Permission.microphone.request();
    }else if(!status[Permission.camera].isGranted){
      await Permission.camera.request();
    }
  }
}
