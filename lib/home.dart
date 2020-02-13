import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/pages/chat_page.dart';
import 'package:datingapp/pages/match/match_main.dart';
import 'package:datingapp/pages/receive_page.dart';
import 'package:datingapp/pages/send_page.dart';
import 'package:datingapp/widgets/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MatchMain(),
    SendPage(),
    ReceivePage(),
    ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Margaret',
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: Container(
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [
//              Colors.white,
//              Colors.white,
//            ],
//          ),
//        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_made),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_received),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(''),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(index),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: GestureDetector(onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()));
            }, child: CircleAvatar(
              child: Consumer<MyUserData>(builder: (context, value, child) {
                return Text(value.data.nickname);
              }),
            )),
            decoration: BoxDecoration(color: Colors.yellow[100]),
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
              Provider.of<MyUserData>(context, listen: false).clearUser();
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
