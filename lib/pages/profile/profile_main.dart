import 'package:aero_meet/pages/firebase_chat/modal/chat_user.dart';
import 'package:aero_meet/pages/firebase_chat/views/chat_authenticate.dart';
import 'package:aero_meet/pages/profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProfileMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ChatUser>(context);

    return user == null ? ChatAuthenticate():ProfilePage();
  }
}
