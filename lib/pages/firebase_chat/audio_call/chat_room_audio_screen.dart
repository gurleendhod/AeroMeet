import 'dart:async';
import 'package:aero_meet/pages/firebase_chat/audio_call/bloc/chat_room_screen_audio_bloc.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/message.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:aero_meet/pages/firebase_chat/views/conversation_screen.dart';
import 'package:aero_meet/pages/firebase_chat/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomAudioScreen extends StatelessWidget {
  final ChatProfile friend;
  final currentUserUid;
  final channel;

  const ChatRoomAudioScreen(
      {this.friend, this.currentUserUid, Key key, this.channel})
      : super(key: key);

  void _onCallEnd(BuildContext context) {
    ///make counter value to 0
    // counterValue.value = 0;

    //database instance
    ChatDatabase _database = ChatDatabase();

    Map<String, dynamic> map = {
      'type': 'call_end',
      'message': 'call ended',
      'status': 'ended',
      'from': '$currentUserUid',
      'timestamp': '${Timestamp.now().seconds}'
    };

    ///create chat room for current user
    _database.createChatRoom(currentUserUid, friend.uid, map);

    ///create chat room for chat user
    _database.createChatRoom(friend.uid, currentUserUid, map);

    ///update friend list for current user
    _database.createFriend(currentUserUid, friend.uid, 'call ended');

    ///update friend list for chat user
    _database.createFriend(friend.uid, currentUserUid, 'call ended');
    //Navigator.pop(context);
  }

  void _onSwitchMicroPhone(BuildContext context) {
    BlocProvider.of<ChatRoomAudioScreenBloc>(context).add(SwitchMicroPhone());
  }

  void _onSwitchSpeakerPhone(BuildContext context) {
    BlocProvider.of<ChatRoomAudioScreenBloc>(context).add(SwitchSpeakerPhone());
  }

  // void periodicTimer(int value) {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     counterValue.value = ++value;
  //     counterValue.notifyListeners();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomAudioScreenBloc, ChatRoomAudioScreenState>(
        builder: (BuildContext context, ChatRoomAudioScreenState state) {
      return _buildWidget(context, state);
    });
  }

  Widget _buildWidget(BuildContext context, ChatRoomAudioScreenState state) {
    // periodicTimer(counterValue.value);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: state.loading
              ? CircularProgressIndicator()
              : Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      child: StreamBuilder<List<Message>>(
                        stream: ChatDatabase()
                            .getChatRoomMessage(currentUserUid, friend.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.first.type == 'call_end') {
                              if (snapshot.data.first.from != currentUserUid) {
                                Future.delayed(Duration(milliseconds: 100), () {
                                  Navigator.of(context).pop();
                                });
                                return Scaffold(
                                  body: Loading(),
                                );
                              }
                            }
                            return Container();
                          }
                          return Container();
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Image.asset(
                          'assets/images/profile_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: _toolbar(context, state)),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          child: Text(
                            "${friend.name}",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                  ],
                ),
        ),
      ),
    );
  }

//   /// Video layout wrapper
//   Widget _viewRows(BuildContext context, ChatRoomScreenState state) {
//     final views = _getRenderViews(context, state);
//     print('length ${views.length}');
//     switch (views.length) {
//       case 0:
//         return Container(
//               child: RtcLocalView.SurfaceView());
//       case 1:
//         return Container(
//             child: Stack(
//           children: <Widget>[
//             Positioned(
//                 top: 0.0, right: 0.0, left: 0.0, bottom: 0.0, child: views[0]),
//             Positioned(
//                 top: 20.0,
//                 right: 20.0,
//                 child: Container(width: 100.0, height: 150, child: RtcLocalView.SurfaceView())),
//           ],
//         ));
// //      case 3:
// //        return Container(
// //            child: Column(
// //          children: <Widget>[
// //            _expandedVideoRow(views.sublist(0, 2)),
// //            _expandedVideoRow(views.sublist(2, 3))
// //          ],
// //        ));
// //      case 4:
// //        return Container(
// //            child: Column(
// //          children: <Widget>[
// //            _expandedVideoRow(views.sublist(0, 2)),
// //            _expandedVideoRow(views.sublist(2, 4))
// //          ],
// //        ));
//       default:
//     }
//     return Container();
//   }
//
  /// Toolbar layout
  Widget _toolbar(BuildContext context, ChatRoomAudioScreenState state) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onSwitchMicroPhone(context),
            child: Icon(
              state.openMicrophone ? Icons.mic_off : Icons.mic,
              color: state.openMicrophone ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: state.openMicrophone ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => _onSwitchSpeakerPhone(context),
            child: Icon(
              state.openSpeaker ? Icons.speaker : Icons.speaker_rounded,
              color: state.openSpeaker ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: state.openSpeaker ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }
}
