import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/utils/adjust_size.dart';

class NoReceive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          '아직 호감이 없어요',
          style: TextStyle(
              fontFamily: FontFamily.jua,
              fontSize: screenAwareTextSize(16, context)),
        ),
        SpinKitChasingDots(
          color: Colors.redAccent,
          size: screenAwareTextSize(32, context),
        )
      ],
    );
  }
}
