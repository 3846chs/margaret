import 'dart:convert';

import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/utils/prefs_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final firebaseMessaging = FirebaseMessaging();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void registerNotification(MyUserData myUserData) async {
  firebaseMessaging.requestNotificationPermissions();

  await prefsProvider.initialize();

  firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
    print('onMessage: $message');
    final notification = message['notification'];
    if (prefsProvider.isNotificationEnabled(notification['title'])) {
      showNotification(notification);
    }
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

void configLocalNotification() {
  final initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final initializationSettingsIOS = IOSInitializationSettings();
  final initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showNotification(message) async {
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'com.datingapp.datingapp',
    'Margaret',
    'your channel description',
    playSound: true,
    enableVibration: true,
    importance: Importance.Max,
    priority: Priority.High,
  );
  final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics,
    iOSPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
      message['body'].toString(), platformChannelSpecifics,
      payload: json.encode(message));
}
