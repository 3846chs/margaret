import 'package:margaret/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:margaret/pages/qna/my_questions.dart';
import 'package:margaret/pages/qna/peer_questions.dart';
import 'package:margaret/pages/qna/write_question.dart';

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
          floatingActionButton: FloatingActionButton(
            heroTag: 'WriteQuestion',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WriteQuestion()));
            },
            backgroundColor: Colors.grey[100],
            child: Icon(
              Icons.edit,
              color: pastel_purple,
              size: 30,
            ),
          ),
          appBar: TabBar(
            indicatorColor: Colors.black54,
            tabs: <Widget>[
              Tab(
                text: '이성 질문',
              ),
              Tab(
                text: '돌아온 답변',
              ),
            ],
          ),
          body: TabBarView(
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
