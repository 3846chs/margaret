import 'package:margaret/constants/colors.dart';
import 'package:margaret/pages/send/peer_questions.dart';
import 'package:flutter/material.dart';
import 'package:margaret/pages/send/returned_answers.dart';
import 'package:margaret/pages/send/write_question.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                        context, MaterialPageRoute(builder: (context) => WriteQuestion()));

          },
          backgroundColor: Colors.grey[100],
          child: Icon(
            Icons.edit,
            color: pastel_purple,
            size: 30,
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              fillOverscroll: true,
              child: Scaffold(
                appBar: TabBar(
                  indicatorColor: Colors.black54,
                  controller: tabController,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        '이성 질문',
                      ),
                    ),
                    Tab(
                      child: Text(
                        '돌아온 답변',
                      ),
                    ),
                  ],
                ),
                body: TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    PeerQuestions(),
                    ReturnedAnswers(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
