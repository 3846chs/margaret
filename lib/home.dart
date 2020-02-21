import 'dart:convert';

import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/firebase/storage_provider.dart';
import 'package:datingapp/pages/chat_page.dart';
import 'package:datingapp/pages/match/match_main.dart';
import 'package:datingapp/pages/receive_page.dart';
import 'package:datingapp/pages/send_page.dart';
import 'package:datingapp/profiles/my_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInitialized = false;
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MatchMain(),
    SendPage(),
    ReceivePage(),
    ChatPage(),
  ];

  final firebaseMessaging = FirebaseMessaging();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void registerNotification(MyUserData myUserData) {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
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
    final platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {
    final myUserData = Provider.of<MyUserData>(context, listen: false);

    if (!_isInitialized) {
      registerNotification(myUserData);
      configLocalNotification();
      _isInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Margaret',
          style: GoogleFonts.handlee(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFFCCDDFF), Color(0xFFFFEEFF)])),
        ),
      ),
      body: Container(
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      drawer: _buildDrawer(myUserData),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.streetView),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.paperPlane),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidHeart),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.commentDots),
            title: Text(''),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(index),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      {String activeIconPath, String iconPath}) {
    return BottomNavigationBarItem(
      activeIcon:
          activeIconPath == null ? null : ImageIcon(AssetImage(activeIconPath)),
      icon: ImageIcon(AssetImage(iconPath)),
      title: Text(''),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer(MyUserData myUserData) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyProfile()));
              },
              child: Consumer<MyUserData>(builder: (context, value, child) {
                return FutureBuilder<String>(
                  future: storageProvider
                      .getImageUri("profiles/" + value.userData.profiles[0]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            snapshot.data,
                          ),
                        ),
                      );
                    }
                    return CircleAvatar(
                        child:
                            ClipOval(child: const CircularProgressIndicator()));
                  },
                );
              }),
            ),
            decoration: BoxDecoration(color: Color(0xFFDCD3FF)),
          ),
          ListTile(
            title: Text('공지사항'),
            onTap: null,
          ),
          ListTile(
            title: Text('설정'),
            onTap: null,
          ),
          ListTile(
            title: Text('로그아웃'),
            onTap: () {
              Navigator.pop(context); // 없으면 에러
              myUserData.clearUser();
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
