import 'dart:convert';

import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/utils/prefs_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final firebaseMessaging = FirebaseMessaging();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final androidPlatformChannelSpecifics = AndroidNotificationDetails(
  'com.margaret.margaret',
  'Margaret',
  'Margaret, Dating App',
);
final iOSPlatformChannelSpecifics = IOSNotificationDetails();
final platformChannelSpecifics = NotificationDetails(
  androidPlatformChannelSpecifics,
  iOSPlatformChannelSpecifics,
);

void registerNotification(MyUserData myUserData) async {
  firebaseMessaging.requestNotificationPermissions();

  await prefsProvider.initialize();

  firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
    print('onMessage: $message');
    final notification = message['notification'];
    showNotification(notification);
    return;
  }, onResume: (Map<String, dynamic> message) {
    print('onResume: $message');
    return;
  }, onLaunch: (Map<String, dynamic> message) {
    print('onLaunch: $message');
    return;
  });

  firebaseMessaging.getToken().then((token) {
    print('token: $token');
    myUserData.setPushToken(token);
  }).catchError((err) {
    print(err.message);
  });
}

void configLocalNotification() async {
  final initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final initializationSettingsIOS = IOSInitializationSettings();
  final initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin.cancel(1);

  if (prefsProvider.getTodayQuestionAlarm()) {
    flutterLocalNotificationsPlugin.showDailyAtTime(1, "밤 12시가 되었습니다!",
        "오늘의 질문을 확인하려면 클릭하세요.", Time(), platformChannelSpecifics);
  }
}

void showNotification(message) async {
  if (prefsProvider.isNotificationEnabled(message['title'])) {
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }
}
