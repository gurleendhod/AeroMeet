import 'package:aero_meet/constant/app_config.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room_screen/call_button.dart';

class OutgoingCallScreen extends StatefulWidget {

  final currentUserUid;
  final toUserUid;
  final name;

  OutgoingCallScreen({this.currentUserUid, this.toUserUid,this.name});

  @override
  _OutgoingCallScreenState createState() => _OutgoingCallScreenState();
}

class _OutgoingCallScreenState extends State<OutgoingCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              color: CustomColors().mainColor(1.0),
              padding: EdgeInsets.only(top: 5, bottom: 6),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.lock,
                              color: Colors.white.withOpacity(.6),
                              size: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: " End-to-end encrypted",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white.withOpacity(.6),
                            ),
                          ),
                        ]),
                      ),
                      // Container(
                      //   margin: EdgeInsets.all(8.0),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     shape: BoxShape.circle,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(.1),
                      //         spreadRadius: 4,
                      //         blurRadius: 5,
                      //       )
                      //     ],
                      //   ),
                      //   child: CircleAvatar(
                      //     backgroundImage: args.image != null
                      //         ? Image.file(args.image).image
                      //         : AssetImage('assets/default-profile.jpg'),
                      //     radius: 47.0,
                      //   ),
                      // ),
                      Text(
                        "${widget.name}",
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Calling",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0xFF202930),
              padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      _onCallEnd(context);
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _onCallEnd(BuildContext context) {
    //database instance
    ChatDatabase _database = ChatDatabase();

    Map<String, dynamic> map = {
      'type': 'call_end',
      'message': 'call ended',
      'status': 'ended',
      'from': '${widget.currentUserUid}',
      'timestamp': '${Timestamp.now().seconds}'
    };

    ///create chat room for current user
    _database.createChatRoom(widget.currentUserUid, widget.toUserUid, map);

    ///create chat room for chat user
    _database.createChatRoom(widget.toUserUid, widget.currentUserUid, map);

    ///update friend list for current user
    _database.createFriend(widget.currentUserUid, widget.toUserUid, 'call ended');

    ///update friend list for chat user
    _database.createFriend(widget.toUserUid, widget.currentUserUid, 'call ended');
    Navigator.pop(context);
  }
}
