import 'package:margaret/constants/colors.dart';
import 'package:margaret/pages/send/peer_questions.dart';
import 'package:margaret/pages/send/returned_answers.dart';
import 'package:margaret/pages/send/write_question.dart';
import 'package:flutter/material.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
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
              ReturnedAnswers(),
            ],
          ),
        ),
      ),
    );
  }
}
