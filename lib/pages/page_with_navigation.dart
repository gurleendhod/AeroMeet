import 'dart:convert';
import 'package:aero_meet/components/bottom_nav_bar.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:aero_meet/pages/firebase_chat/views/auth_page.dart';
import 'package:aero_meet/pages/profile/profile_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard/dashboard.dart';
import 'firebase_chat/audio_call/incoming_audio_call_screen.dart';
import 'firebase_chat/modal/chat_user.dart';
import 'firebase_chat/video_call/incoming_call_screen.dart';
import 'firebase_chat/views/conversation_screen.dart';
import 'history/history_screen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _widget = Dashboard();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //database instance
  ChatDatabase _database = ChatDatabase();
  ChatUser currentUser;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    ///method to get messages
    ///when app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage: ${message.notification.title}');
      final notification = message.notification;
      ///decode user_data map
      ///user_data contain the information who sen notification
      ///or who call
      ChatProfile chatProfile = message.data['user_data'] != null
          ? ChatProfile.fromJson(jsonDecode(message.data['user_data']))
          : null;
      //navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => ChatConversation(friend: user)));
      if (chatProfile != null && message.data['type'] != 'message')
        Navigator.of(navigatorKey.currentContext).push(MaterialPageRoute(
            builder: (context) => message.data['type'] == 'call'
            ///type is call(video call) open video call screen
            ///else type is audio call open audio call screen
                ? IncomingCallScreen(profile: chatProfile)
                : IncomingAudioCallScreen(
                    profile: chatProfile,
                    currentUserUid: currentUser.uid,
                  )));
      //await  notificationPlugin.showNotification(title: notification.title,body: notification.body);
    });

    ///handle event on application open
    ///replacement for onLaunch and onResume handlers
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: ${message.notification.title}');
      final status = message.data['type'];
      ChatProfile friend = message.data['user_data'] != null
          ? ChatProfile.fromJson(jsonDecode(message.data['user_data']))
          : null;
      if (friend != null) {
        // Map<String, dynamic> map = {
        //   'type': '$status',
        //   'message': '$status received',
        //   'status': status == 'message' ? 'seen' : 'received',
        //   'from': '${friend.uid}',
        //   'timestamp': '${Timestamp.now().seconds}'
        // };

        // ///create chat room for current user
        // _database.createChatRoom(currentUser.uid, friend.uid, map);
        //
        // ///create chat room for chat user
        // _database.createChatRoom(friend.uid, currentUser.uid, map);
        ///navigate to chat conversation screen
        // Navigator.of(navigatorKey.currentContext).push(MaterialPageRoute(
        //     builder: (context) => ChatConversation(friend: friend)));

        if (status != 'message') {
          Navigator.of(navigatorKey.currentContext).push(MaterialPageRoute(
              builder: (context) =>
              message.data['type'] == 'call'

              ///type is call(video call) open video call screen
              ///else type is audio call open audio call screen
                  ? IncomingCallScreen(profile: friend)
                  : IncomingAudioCallScreen(
                profile: friend,
                currentUserUid: currentUser.uid,
              )));
        }else{
          Navigator.of(navigatorKey.currentContext).push(MaterialPageRoute(
              builder: (context) => ChatConversation(friend: friend)));
        }
      }
    });

    // AwesomeNotifications().createdStream.listen((receivedNotification) {
    //   String createdSourceText =
    //   AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
    //   print('$createdSourceText notification created');
    // });
    //
    // AwesomeNotifications().displayedStream.listen((receivedNotification) {
    //   String createdSourceText =
    //   AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
    //   print('$createdSourceText notification displayed');
    // });
    //
    // AwesomeNotifications().dismissedStream.listen((receivedNotification) {
    //   String dismissedSourceText = AssertUtils.toSimpleEnumString(
    //       receivedNotification.dismissedLifeCycle);
    //   print('Notification dismissed on $dismissedSourceText');
    // });

    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }


  @override
  Widget build(BuildContext context) {

    currentUser = Provider.of<ChatUser>(context);

    return StreamProvider<ChatProfile>.value(
      initialData: null,
      value: currentUser != null ? ChatDatabase().getUserProfile(currentUser.uid) : null,
      builder: (_,__){
        return Scaffold(
          key: navigatorKey,
          bottomNavigationBar: BottomNavBar(
            onIconPressedCallback: onBottomIconPressed,
          ),
          body: _widget,
        );
      },
    );
  }

  void onBottomIconPressed(int index) {
    switch (index) {
      case 1:
        setState(() {
          _widget = Dashboard();
        });
        break;
      case 2:
        setState(() {
          _widget = HistoryScreen();
        });
        break;
      case 3:
        setState(() {
          _widget = AuthPage();
        });
        break;
      case 4:
        setState(() {
          _widget = ProfileMainPage();
        });
        break;
    }
  }
}
