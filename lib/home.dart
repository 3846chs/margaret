import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/data/provider/alarm_data.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/pages/account_setting_page.dart';
import 'package:margaret/pages/alarm_page.dart';
import 'package:margaret/pages/chat/chat_page.dart';
import 'package:margaret/pages/match/match_page.dart';
import 'package:margaret/pages/qna/qna_page.dart';
import 'package:margaret/pages/receive_page.dart';
import 'package:margaret/profiles/temp_my_profile.dart';
import 'package:margaret/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/widgets/user_avatar.dart';
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
    MatchPage(),
    QnaPage(),
    ReceivePage(),
    ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final myUserData = Provider.of<MyUserData>(context, listen: false);
    final alarmData = Provider.of<AlarmData>(context, listen: false);

    if (!_isInitialized) {
      registerNotification(myUserData);
      configLocalNotification();
      alarmData.getData(myUserData.userData.reference);
      _isInitialized = true;
    }

    return Consumer<MyUserData>(
      builder: (context, myUserData, _) {
        return Scaffold(
          appBar: _buildAppBar(myUserData),
          body: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
          drawer: _buildDrawer(myUserData),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  AppBar _buildAppBar(MyUserData myUserData) {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return InkWell(
            borderRadius: BorderRadius.circular(40.0),
            onTap: () => Scaffold.of(context).openDrawer(),
            child: UserAvatar(user: myUserData.userData, width: 40.0),
          );
        },
      ),
      title: Row(
        children: <Widget>[
          Spacer(flex: 1),
          Text(
            '마    가    렛',
            style: TextStyle(
              fontFamily: FontFamily.jua,
              color: Colors.purple[300],
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
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
      selectedItemColor: pastel_purple,
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
              child: UserAvatar(user: myUserData.userData),
            ),
            decoration: const BoxDecoration(color: Color(0xFFDCD3FF)),
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
                  MaterialPageRoute(builder: (context) => AlarmPage()));
            },
          ),
          ListTile(
            title: Text('계정 설정'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountSetting(
                            myUserData: myUserData,
                          )));
            },
          ),
        ],
      ),
    );
  }
}
