// import 'dart:async';
// import 'dart:math';
// import 'dart:ui';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// AwesomeNotificationPlugin awesomeNotificationPlugin =
//     AwesomeNotificationPlugin._();
//
// class AwesomeNotificationPlugin {
//   String _firebaseAppToken = '';
//
//   AwesomeNotificationPlugin._() {
//     init();
//   }
//
//   init() {
//
//     print('calllll');
//
//     ///Initialize the plugin (on main.dart), with at least one native icon and one channel
//     AwesomeNotifications().initialize(
//         // set the icon to null if you want to use the default app icon
//         null,
//         [
//           NotificationChannel(
//               channelKey: 'basic_channel',
//               channelName: 'Basic notifications',
//               channelDescription: 'Notification channel for basic tests',
//               defaultColor: Color(0xFF9D50DD),
//               ledColor: Colors.white)
//         ]);
//
//     initializeFirebaseService();
//   }
//
//   ///Request the user authorization to send local and push notifications
//   ///(Remember to show a dialog alert to the user before call this request)
//   Future<bool> checkNotificationPermission() async {
//     Completer<bool> completer = Completer();
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         // Insert here your friendly dialog box before call the request method
//         // This is very important to not harm the user experience
//         completer.complete(
//             AwesomeNotifications().requestPermissionToSendNotifications());
//       }
//       completer.complete(isAllowed);
//     });
//     return completer.future;
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initializeFirebaseService() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     String firebaseAppToken = await messaging.getToken(
//           // https://stackoverflow.com/questions/54996206/firebase-cloud-messaging-where-to-find-public-vapid-key
//           vapidKey: 'BEHiIZ5u1c4O1Ms4EPgBUAI8vc50HK6fQnRg_MNtTeIZNbCNLUKg-xxiPuykqsy_8jx1rs0XJ9WjJuCkqNazVRs',
//         ) ??
//         '';
//
//     if (StringUtils.isNullOrEmpty(firebaseAppToken,
//         considerWhiteSpaceAsEmpty: true)) return;
//
//     _firebaseAppToken = firebaseAppToken;
//
//     print('Firebase token: $firebaseAppToken');
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');
//
//       if (
//           // This step (if condition) is only necessary if you pretend to use the
//           // test page inside console.firebase.google.com
//           !StringUtils.isNullOrEmpty(message.notification?.title,
//                   considerWhiteSpaceAsEmpty: true) ||
//               !StringUtils.isNullOrEmpty(message.notification?.body,
//                   considerWhiteSpaceAsEmpty: true)) {
//         print('Message also contained a notification: ${message.notification}');
//
//         String imageUrl;
//         imageUrl ??= message.notification?.android?.imageUrl;
//         imageUrl ??= message.notification?.apple?.imageUrl;
//
//         // https://pub.dev/packages/awesome_notifications#notification-types-values-and-defaults
//         Map<String, dynamic> notificationAdapter = {
//           PUSH_NOTIFICATION_CONTENT: {
//             NOTIFICATION_ID: Random().nextInt(2147483647),
//             NOTIFICATION_CHANNEL_KEY: 'basic_channel',
//             NOTIFICATION_TITLE: message.notification?.title,
//             NOTIFICATION_BODY: message.notification?.body,
//             NOTIFICATION_LAYOUT:
//                 StringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
//             NOTIFICATION_BIG_PICTURE: imageUrl
//           }
//         };
//
//         AwesomeNotifications()
//             .createNotificationFromJsonData(notificationAdapter);
//       } else {
//         AwesomeNotifications().createNotificationFromJsonData(message.data);
//       }
//     });
//   }
//
//   Future<void> showNotificationWithActionButtons({title, body}) async {
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: 0,
//             channelKey: 'basic_channel',
//             title: '$title',
//             body: '$body',
//             payload: {'uuid': 'user-profile-uuid'}),
//         actionButtons: [
//           NotificationActionButton(
//               key: 'Accept', label: 'accept', autoCancel: true),
//           NotificationActionButton(
//               key: 'Cancel', label: 'cancel', autoCancel: true, enabled: false)
//         ]);
//   }
// }
