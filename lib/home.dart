import 'package:cached_network_image/cached_network_image.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/pages/chat_page.dart';
import 'package:margaret/pages/match/match_main.dart';
import 'package:margaret/pages/qna/qna_main.dart';
import 'package:margaret/pages/receive_page.dart';
import 'package:margaret/profiles/temp_my_profile.dart';
import 'package:margaret/utils/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInitialized = false;
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MatchMain(),
    QnAMain(),
    ReceivePage(),
    ChatPage(),
  ];

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
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: CircleAvatar(
                child: ClipOval(
                  child: Consumer<MyUserData>(
                    builder: (context, value, child) {
                      return CachedNetworkImage(
                        width: 40,
                        imageUrl: "profiles/${value.userData.profiles[0]}",
                        cacheManager: StorageCacheManager(),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.account_circle),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        title: Row(
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Text(
              '마    가    렛',
              style: TextStyle(
                  fontFamily: FontFamily.jua, color: Colors.purple[300]),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      drawer: _buildDrawer(myUserData),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
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
    );
  }

  Drawer _buildDrawer(MyUserData myUserData) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TempMyProfile(user: myUserData.userData)));
              },
              child: CircleAvatar(
                child: ClipOval(
                  child: Consumer<MyUserData>(
                    builder: (context, value, child) {
                      return CachedNetworkImage(
                        imageUrl: "profiles/${value.userData.profiles[0]}",
                        cacheManager: StorageCacheManager(),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.account_circle),
                      );
                    },
                  ),
                ),
              ),
            ),
            decoration: const BoxDecoration(color: Color(0xFFDCD3FF)),
          ),
          ListTile(
            title: Text('공지사항'),
            onTap: null,
          ),
          ListTile(
            title: Text('오늘의 질문 제보'),
            onTap: () async {
              const url =
                  'https://docs.google.com/forms/d/e/1FAIpQLSfOH4Q7M6i5q0BMu4TGe-_P_XoDjfIvzNTTKYTsoxjr5ZRqCw/viewform';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            title: Text('알림 설정'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingAlarm()));
            },
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

class SettingAlarm extends StatefulWidget {
  @override
  _SettingAlarmState createState() => _SettingAlarmState();
}

class _SettingAlarmState extends State<SettingAlarm> {
  bool matchAlarm = true; // 이성 3명과 매칭되었을 때 알람
  bool receiveAlarm = true; // 자신에게 호감 보낸 이성 카드가 도착했을 때 알람
  bool newChatAlarm = true; // 새로운 채팅이 생겼을 때 (각 채팅방에 개별 알람 on/off 기능있음)
  bool newTodayQuestion = true; // 자정에 새로운 질문 업데이트 되었을 때 알람

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('알림 설정'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Text(
                      '매칭 알림',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Switch(
                      value: matchAlarm,
                      onChanged: (value) {
                        setState(() {
                          matchAlarm = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Text(
                      '호감 알림',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Switch(
                      value: receiveAlarm,
                      onChanged: (value) {
                        setState(() {
                          receiveAlarm = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Text(
                      '새로운 채팅 알림',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Switch(
                      value: newChatAlarm,
                      onChanged: (value) {
                        setState(() {
                          newChatAlarm = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Text(
                      '오늘의 질문 알림',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Switch(
                      value: newTodayQuestion,
                      onChanged: (value) {
                        setState(() {
                          newTodayQuestion = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
