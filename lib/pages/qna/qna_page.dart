import 'package:flutter/material.dart';
import 'package:margaret/pages/qna/my_questions.dart';
import 'package:margaret/pages/qna/peer_questions.dart';

class QnaPage extends StatefulWidget {
  @override
  _QnaPageState createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.black54,
          tabs: <Widget>[
            Tab(
              text: '이성 질문', // 아이콘 추가할 예정
            ),
            Tab(
              text: '돌아온 답변', // 아이콘 추가할 예정
            ),
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            PeerQuestions(),
            MyQuestions(),
          ],
        ),
      ),
    );
  }
}
