import 'package:aero_meet/constant/app_config.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:flutter/material.dart';
import 'chat_room_screen/call_button.dart';

class IncomingCallScreen extends StatefulWidget {
  final ChatProfile profile;

  IncomingCallScreen({this.profile});

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
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
                        "${widget.profile.name}",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        "AeroMeet Video Call",
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      )
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
                children: <Widget>[
                  BottomButton(
                    profile: widget.profile,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Swipe Up to Accept",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
