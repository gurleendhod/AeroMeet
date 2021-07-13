import 'package:aero_meet/app_theme/theme.dart';
import 'package:aero_meet/pages/dashboard/host_service/host_service.dart';
import 'package:aero_meet/pages/dashboard/model/host_model.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_user.dart';
import 'package:aero_meet/pages/firebase_chat/services/auth.dart';
import 'package:aero_meet/pages/page_with_navigation.dart';
import 'package:aero_meet/utils/notification_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

const hostBoxName = 'host_box';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(HostModelAdapter());
  await Hive.openBox<HostModel>(hostBoxName);

  ///top-level function
  ///to handle background messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HostService>(create: (context) => HostService()),
        StreamProvider<ChatUser>(
          initialData: null,
          create: (context) => ChatAuth().getChatUser,
        ),
        StreamProvider<List<HostModel>>(
          initialData: null,
          create: (context) => HostService().hosts,
        ),
      ],
      child: MaterialApp(
        title: 'AeroMeet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().lightTheme,
        home: MainPage(),
      ),
    );
  }
}

///handle background messaging
///It must not be an anonymous function.
/// It must be a top-level function (e.g. not a class method which requires initialization).
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("onBackgroundMessage: ${message.from}");
  print("data: ${message.notification.body}");
  // ChatProfile user = ChatProfile.fromJson(jsonDecode(message.data['user_data']));
  //navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => ChatConversation(friend: user)));
  // Navigator.of(rootNavigatorKey.currentContext).push(MaterialPageRoute(builder: (context) => ChatConversation(friend: user)));

  await notificationPlugin.showNotification(
      title: message.notification.title, body: message.notification.body);

  // ///awesome_notification
  // await AwesomeNotifications().createNotificationFromJsonData(message.data);
  // await awesomeNotificationPlugin.showNotificationWithActionButtons(title: message.notification.title,body: message.notification.body);
}
