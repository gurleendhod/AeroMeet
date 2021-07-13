import 'package:aero_meet/constant/custom_styles.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget userStatusCard(ChatProfile profile, context) {
  print(profile.status);
  return GestureDetector(
    onTap: () {
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => EditProfileScreen(authUser: authUser,profileUpdatedCallback:authUserUpdated ,)),
//      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Status',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              profile.status != null || profile.status != ''
                  ? '${profile.status}'
                  : 'Welcome to AeroMeet!',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: CustomStyles.boxShadow,
        color: Colors.white,
      ),
    ),
  );
}
