import 'package:flutter/material.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/utils/adjust_size.dart';

class InvalidUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '탈퇴한 회원입니다',
        style: TextStyle(
            fontFamily: FontFamily.jua,
            fontSize: screenAwareTextSize(16, context)),
      ),
    );
  }
}
