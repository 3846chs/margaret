import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/utils/base_height.dart';
// PeerQuestions 가 비었을 경우 페이지
class EmptyPeerQuestionsCard extends StatelessWidget {
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
            height: screenAwareSize(30, context),
          ),
          Text(
            '더 이상 질문이 없어요ㅠㅠ',
            style: TextStyle(fontFamily: FontFamily.jua, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
