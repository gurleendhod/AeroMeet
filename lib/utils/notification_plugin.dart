import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File, Platform;
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

class NotificationPlugin {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    _initializePlatformSpecifies();
  }

  _initializePlatformSpecifies() {
    final initialAndroidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initialIosSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
          didReceivedLocalNotificationSubject.add(receivedNotification);
        });
    initializationSettings =
        InitializationSettings(android: initialAndroidSettings,iOS: initialIosSettings);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersion(Function onNotificationForLowerVersion) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationForLowerVersion(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      onNotificationClick(payload);
      return;
    });
  }

  Future<void> showNotification({title,body}) async {
    final androidChannelSpecifies = AndroidNotificationDetails(
        'Online', 'online service', 'Online dating',
        importance: Importance.max, priority: Priority.high,autoCancel: false,enableVibration: true,);
    final iosChannelSpecifies = IOSNotificationDetails();
    final platformChannelSpecifies = NotificationDetails(android: androidChannelSpecifies, iOS: iosChannelSpecifies);
    flutterLocalNotificationsPlugin.show(0, '$title', '$body', platformChannelSpecifies, payload: 'payload',);
  }

  Future<void> showScheduleNotification() async {
    final scheduleNotificationDateTime =
        DateTime.now().add(Duration(seconds: 10));
    final androidChannelSpecifies = AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME', 'CHANNEL_DESCRIPTION',
        importance: Importance.high, priority: Priority.high);
    final iosChannelSpecifies = IOSNotificationDetails();
    final platformChannelSpecifies =
        NotificationDetails(android: androidChannelSpecifies, iOS: iosChannelSpecifies);
    flutterLocalNotificationsPlugin.schedule(0, 'title', 'body',
        scheduleNotificationDateTime, platformChannelSpecifies,
        payload: 'payload');
  }

  Future<void> showNotificationWithAttachment() async {
    final attachment = await _downloadAndSaveFile(
        'https://i1.wp.com/lanecdr.org/wp-content/uploads/2019/08/placeholder.png?w=1200&ssl=1',
        'attachment');
    final iosPlatformSpecifies = IOSNotificationDetails(
      attachments: [IOSNotificationAttachment(attachment)],
    );
    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachment),
      contentTitle: '<b>Attached Image</b>',
      htmlFormatContentTitle: true,
      summaryText: 'Test Image',
      htmlFormatSummaryText: true,
    );
    final androidChannelSpecifies = AndroidNotificationDetails(
        'CHANNEL_ID 2', 'CHANNEL_NAME 2', 'CHANNEL_DESCRIPTION 2',
        priority: Priority.high,
        importance: Importance.high,
        styleInformation: bigPictureStyleInformation);
    final notificationDetails =
        NotificationDetails(android: androidChannelSpecifies, iOS: iosPlatformSpecifies);
    await flutterLocalNotificationsPlugin.show(0, 'title with attachment',
        'body with attachment', notificationDetails);
  }
  _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
  Future<void> repeatNotification() async {
    final androidChannelSpecifies = AndroidNotificationDetails(
        'CHANNEL_ID 3', 'CHANNEL_NAME 3', 'CHANNEL_DESCRIPTION 3',
        importance: Importance.high, priority: Priority.high);
    final iosChannelSpecifies = IOSNotificationDetails();
    final platformChannelSpecifies =
    NotificationDetails(android:androidChannelSpecifies, iOS: iosChannelSpecifies);
    flutterLocalNotificationsPlugin
        .periodicallyShow(0, 'repeat title', 'repeat body', RepeatInterval.everyMinute,platformChannelSpecifies, payload: 'payload');
  }
  Future<void> showDailyNotificationAtTime() async {
    final androidChannelSpecifies = AndroidNotificationDetails(
        'CHANNEL_ID 4', 'CHANNEL_NAME 4', 'CHANNEL_DESCRIPTION 4',
        importance: Importance.high, priority: Priority.high);
    final time = Time(18,34,0);
    final iosChannelSpecifies = IOSNotificationDetails();
    final platformChannelSpecifies =
    NotificationDetails(android:androidChannelSpecifies, iOS: iosChannelSpecifies);
    flutterLocalNotificationsPlugin
        .showDailyAtTime(0, 'notification at a time title', 'notification at a time body', time,platformChannelSpecifies, payload: 'payload');
  }
  Future<void> showWeeklyNotificationAtTime() async {
    final androidChannelSpecifies = AndroidNotificationDetails(
        'CHANNEL_ID 4', 'CHANNEL_NAME 4', 'CHANNEL_DESCRIPTION 4',
        importance: Importance.high, priority: Priority.high);
    final time = Time(18,34,0);
    final iosChannelSpecifies = IOSNotificationDetails();
    final platformChannelSpecifies =
    NotificationDetails(android:androidChannelSpecifies, iOS: iosChannelSpecifies);
    flutterLocalNotificationsPlugin
        .showWeeklyAtDayAndTime(0, 'notification at a time title', 'notification at a time body', Day.friday,time,platformChannelSpecifies, payload: 'payload');
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({this.id, this.title, this.body, this.payload});
}
