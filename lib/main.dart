import 'package:dating_app/constants/material_white_color.dart';
import 'package:dating_app/home.dart';
import 'package:dating_app/login.dart';
import 'package:dating_app/root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(DatingApp());

class DatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
      home: RootPage(),
    );
  }
}