import 'package:aero_meet/pages/firebase_chat/views/sign_in.dart';
import 'package:aero_meet/pages/firebase_chat/views/sign_up.dart';
import 'package:flutter/material.dart';

class ChatAuthenticate extends StatefulWidget {
  @override
  _ChatAuthenticateState createState() => _ChatAuthenticateState();
}

class _ChatAuthenticateState extends State<ChatAuthenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !showSignIn ? ChatSignUp(toggleView: toggleView,):ChatSignIn(toggleView: toggleView),
    );
  }
}
