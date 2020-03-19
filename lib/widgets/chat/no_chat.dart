import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:margaret/constants/font_names.dart';

class NoChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          '받은 채팅이 없어요',
          style: TextStyle(fontFamily: FontFamily.jua, fontSize: 20),
        ),
        SpinKitChasingDots(
          color: Colors.redAccent,
        )
      ],
    );
  }
}
