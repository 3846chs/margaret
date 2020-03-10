import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/utils/adjust_size.dart';

// MyQuestions 가 비었을 경우 페이지
class EmptyMyQuestionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.frownOpen,
            size: 100,
          ),
          SizedBox(
            height: screenAwareHeight(30, context),
          ),
          Text(
            '더 이상 답변이 없어요ㅠㅠ',
            style: TextStyle(fontFamily: FontFamily.jua, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
