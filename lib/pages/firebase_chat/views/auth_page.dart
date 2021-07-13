import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_user.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_authenticate.dart';
import 'chat_room.dart';

class AuthPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ChatUser>(context);

    if (user == null) {
      return ChatAuthenticate();
    } else {
      return StreamBuilder<ChatProfile>(
        initialData: null,
        stream: ChatDatabase().getUserProfile( user.uid),
        builder: (context, snapshot) {
          return ChatRoom(myProfile: snapshot.data,);
        },
      );
    }
  }
}
