import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/utils/adjust_size.dart';

// MyQuestions 가 비었을 경우 페이지
class EmptyMyQuestionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          '더 이상 답변이 없어요',
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
