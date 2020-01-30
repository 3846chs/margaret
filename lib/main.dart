import 'package:dating_app/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(DatingApp());

class DatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DatingHome(),
    );
  }
}
