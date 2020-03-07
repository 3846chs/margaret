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
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          indicatorColor: Colors.purple[200],
          tabs: <Widget>[
            Tab(
              text: '랜덤 질문',
            ),
            Tab(
              text: '돌아온 답변',
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
