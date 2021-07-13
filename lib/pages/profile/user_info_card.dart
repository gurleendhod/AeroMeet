import 'dart:convert';
import 'package:aero_meet/constant/custom_styles.dart';
import 'package:aero_meet/pages/firebase_chat/common/common_method.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:aero_meet/pages/profile/edit_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget userInfoCard(ChatProfile profile, context) {
  final ChatDatabase _database = ChatDatabase();

  return GestureDetector(
    onTap: () {
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => EditProfileScreen(authUser: authUser,profileUpdatedCallback:authUserUpdated ,)),
//      );
    },
    child: Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    PickedFile imageFile = await ChatCommon.getImage();

                    ///read the file asynchronously as the image can be very large which may cause blocking of main thread
                    String base64Image =
                        base64Encode(await imageFile.readAsBytes());

                    Map<String, dynamic> map = {
                      'uid': '${profile.uid}',
                      'name': '${profile.name}',
                      'email': '${profile.email}',
                      'identity': '${profile.identity}',
                      'image': base64Image,
                      'status': '${profile.status}',
                    };
                    _database.createAndUpdateUserInfo(map, profile.uid);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: profile.image == null
                        ? Image.network(
                            'https://cdn4.iconfinder.com/data/icons/user-people-2/48/6-512.png',
                            width: 74,
                            height: 74,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            base64Decode(profile.image),
                            scale: 5,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditField(
                                profile: profile,
                              ),
                            ));
                      },
                      child: Text(
                        '${profile.name}',
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(color: CustomStyles.blue),
                      ),
                    ),
                    Text(
                      '${profile.email}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ],
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
