import 'package:flutter/material.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/pages/qna/my_questions.dart';
import 'package:margaret/pages/qna/peer_questions.dart';
import 'package:margaret/pages/qna/write_question.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:provider/provider.dart';

class QnaPage extends StatefulWidget {
  @override
  _QnaPageState createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<MyUserData>(builder: (context, myUserData, _) {
        return Scaffold(
          floatingActionButton: _buildFloatingActionButton(context, myUserData),
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
        );
      }),
    );
  }

  FloatingActionButton _buildFloatingActionButton(
      BuildContext context, MyUserData myUserData) {
    return FloatingActionButton(
      heroTag: 'write_question',
      onPressed: () {
        if (myUserData.userData.numMyQuestions < 1)
          simpleSnackbar(
              context, '오늘 질문 횟수를 모두 사용해버렸어요ㅠㅠ\n하루에 질문은 5개까지만 할 수 있어요!');
        else
          showDialog(context: context, builder: (context) => WriteQuestion());
      },
      backgroundColor: Colors.grey[100],
      child: const Icon(
        Icons.add,
        color: pastel_purple,
        size: 30,
      ),
    );
  }
}
