import 'package:dating_app/constants/material_white_color.dart';
import 'package:dating_app/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(DatingApp());

class DatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: DatingHome(),
    );
  }
}
