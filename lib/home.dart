import 'package:dating_app/pages/chat_page.dart';
import 'package:dating_app/pages/match_page.dart';
import 'package:dating_app/pages/receive_page.dart';
import 'package:dating_app/pages/send_page.dart';
import 'package:flutter/material.dart';

class DatingHome extends StatefulWidget {
  @override
  _DatingHomeState createState() => _DatingHomeState();
}

class _DatingHomeState extends State<DatingHome> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MatchPage(),
    SendPage(),
    ReceivePage(),
    ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue[200],
              Colors.lightBlue[500],
            ],
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlue[600],
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
            child: CircleAvatar(),
            decoration: BoxDecoration(color: Colors.blue),
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
            title: Text('로그아웃 123 456'),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
