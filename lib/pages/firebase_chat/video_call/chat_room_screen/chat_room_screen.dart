import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/message.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:aero_meet/pages/firebase_chat/widgets/loading.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/chat_room_screen_bloc.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class ChatRoomScreen extends StatelessWidget {
  final ChatProfile friend;
  final currentUserUid;

  const ChatRoomScreen({this.friend, this.currentUserUid, Key key})
      : super(key: key);

  void _onCallEnd(BuildContext context) {
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
    Navigator.pop(context);
  }

  void _onToggleMute(BuildContext context) {
    BlocProvider.of<ChatRoomScreenBloc>(context).add(ToggleMute());
  }

  void _onSwitchCamera(BuildContext context) {
    BlocProvider.of<ChatRoomScreenBloc>(context).add(SwitchCamera());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomScreenBloc, ChatRoomScreenState>(
        builder: (BuildContext context, ChatRoomScreenState state) {
      return _buildWidget(context, state);
    });
  }

  Widget _buildWidget(BuildContext context, ChatRoomScreenState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${friend.name}'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: state.loading
            ? CircularProgressIndicator()
            : Stack(
                children: <Widget>[
                  _viewRows(context, state),
//                  _panel(context, state),
                  _toolbar(context, state),
                  Container(
                    alignment: Alignment.topCenter,
                    child: StreamBuilder<List<Message>>(
                      stream: ChatDatabase()
                          .getChatRoomMessage(currentUserUid, friend.uid),
                      builder: (context, snapshop) {
                        if (snapshop.hasData) {
                          if (snapshop.data.first.type == 'call_end') {
                            if (snapshop.data.first.from != currentUserUid) {
                                Future.delayed(Duration(seconds: 2), () {
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
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(
                  //       height: 120.0,
                  //       width: 100.0,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(24.0),
                  //       ),
                  //       child: RtcLocalView.SurfaceView()),
                  // ),
                ],
              ),
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows(BuildContext context, ChatRoomScreenState state) {
    final views = _getRenderViews(context, state);
    print('length ${views.length}');
    switch (views.length) {
      case 0:
        return Container(
              child: RtcLocalView.SurfaceView());
      case 1:
        return Container(
            child: Stack(
          children: <Widget>[
            Positioned(
                top: 0.0, right: 0.0, left: 0.0, bottom: 0.0, child: views[0]),
            Positioned(
                top: 20.0,
                right: 20.0,
                child: Container(width: 100.0, height: 150, child: RtcLocalView.SurfaceView())),
          ],
        ));
//      case 3:
//        return Container(
//            child: Column(
//          children: <Widget>[
//            _expandedVideoRow(views.sublist(0, 2)),
//            _expandedVideoRow(views.sublist(2, 3))
//          ],
//        ));
//      case 4:
//        return Container(
//            child: Column(
//          children: <Widget>[
//            _expandedVideoRow(views.sublist(0, 2)),
//            _expandedVideoRow(views.sublist(2, 4))
//          ],
//        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar(BuildContext context, ChatRoomScreenState state) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onToggleMute(context),
            child: Icon(
              state.muted ? Icons.mic_off : Icons.mic,
              color: state.muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: state.muted ? Colors.blueAccent : Colors.white,
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
            onPressed: () => _onSwitchCamera(context),
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews(
      BuildContext context, ChatRoomScreenState state) {
    final List<SurfaceView> list = [];
    state.users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

}
