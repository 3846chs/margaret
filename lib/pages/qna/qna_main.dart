import 'package:flutter/material.dart';
import 'package:margaret/pages/qna/my_questions.dart';
import 'package:margaret/pages/qna/peer_questions.dart';

class QnAMain extends StatefulWidget {
  @override
  _QnAMainState createState() => _QnAMainState();
}

class _QnAMainState extends State<QnAMain> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
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
      ),
    );
  }
}
