import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_user.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:aero_meet/pages/firebase_chat/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'bloc/arrow_back_stack.dart';

class BottomButton extends StatefulWidget {

  final ChatProfile profile;

  BottomButton({this.profile});

  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> with TickerProviderStateMixin {
  //Timer _incomingCallTimer;
  // int _incomingCallDuration = 40;
  AnimationController _controller;
  bool _visibleAnimation = true;
  double _buttonPosition = 0.0;

  // void startTimer() {
  //   _incomingCallTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_incomingCallDuration < 1) {
  //         _incomingCallTimer.cancel();
  //         Navigator.pop(context);
  //       } else {
  //         _incomingCallDuration = _incomingCallDuration - 1;
  //         // print(incomingCallDuration);
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    // startTimer();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    FlutterRingtonePlayer.playRingtone();

    super.initState();
  }

  @override
  void dispose() {
    //_incomingCallTimer.cancel();
    _controller.dispose();
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ChatDatabase _database = ChatDatabase();
    ///current logged in user
    final currentUser = Provider.of<ChatUser>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {
            _onCallEnd(context, currentUser.uid, widget.profile.uid);
            FlutterRingtonePlayer.stop();
          },
          elevation: 0,
          fillColor: Color(0xFF1A2227),
          child: Icon(
            Icons.call_end,
            size: 27,
            color: Colors.red,
          ),
          constraints: BoxConstraints.tightFor(
            width: 55,
            height: 55,
          ),
          shape: CircleBorder(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 200,
                width: 100,
              ),
              ArrowStack(
                controller: _controller,
              ),
              GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _visibleAnimation = false;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _buttonPosition = details.localPosition.dy.clamp(-200.0, 0.0);
                  });
                  // print(buttonPosition);
                },
                onPanEnd: (details) {
                  setState(() {
                    if (_buttonPosition == -200.0) {

                      FlutterRingtonePlayer.stop();

                      Map<String, dynamic> map = {
                        'type': 'call',
                        'message': 'call received',
                        'status': 'received',
                        'from': '${currentUser.uid}',
                        'timestamp': '${Timestamp.now().seconds}'
                      };

                      ///create chat room for current user
                      _database.createChatRoom(currentUser.uid, widget.profile.uid, map);

                      ///create chat room for chat user
                      _database.createChatRoom(widget.profile.uid, currentUser.uid, map);


                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatConversation(friend: widget.profile)));
                    } else {
                      _buttonPosition = 0.0;
                      _visibleAnimation = true;
                    }
                  });
                },
                child: Transform.translate(
                  offset: Offset(0.0, _buttonPosition),
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Visibility(
                          visible: _visibleAnimation == false,
                          child: MiddleButton(),
                        ),
                        Visibility(
                          visible: _visibleAnimation == true,
                          child: AnimatedMiddleButton(
                            controller: _controller,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // RawMaterialButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   elevation: 0,
        //   fillColor: Color(0xFF1A2227),
        //   child: Icon(
        //     Icons.message,
        //     size: 20,
        //     color: Colors.white,
        //   ),
        //   constraints: BoxConstraints.tightFor(
        //     width: 55,
        //     height: 55,
        //   ),
        //   shape: CircleBorder(),
        // ),
      ],
    );
  }
  void _onCallEnd(BuildContext context,String currentUid,String profileUid) {
    //database instance
    ChatDatabase _database = ChatDatabase();

    Map<String, dynamic> map = {
      'type': 'call_end',
      'message': 'call ended',
      'status': 'ended',
      'from': '$currentUid',
      'timestamp': '${Timestamp.now().seconds}'
    };

    ///create chat room for current user
    _database.createChatRoom(currentUid, profileUid, map);

    ///create chat room for chat user
    _database.createChatRoom(profileUid, currentUid, map);

    ///update friend list for current user
    _database.createFriend(currentUid, profileUid, 'call ended');

    ///update friend list for chat user
    _database.createFriend(profileUid, currentUid, 'call ended');
    Navigator.pop(context);
  }
}
