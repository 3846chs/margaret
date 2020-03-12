import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/pages/qna/write_question.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:margaret/widgets/qna/empty_my_questions_card.dart';
import 'package:margaret/widgets/qna/invalid_card.dart';
import 'package:margaret/widgets/qna/my_questions_card.dart';
import 'package:provider/provider.dart';

class MyQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, _) {
      return Scaffold(
        floatingActionButton: _buildFloatingActionButton(context, myUserData),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: StreamBuilder<QuerySnapshot>(
            stream: myUserData.userData.reference
                .collection(MYQUESTIONS)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0)
                return EmptyMyQuestionsCard();

              final firstDocument =
                  snapshot.data.documents.first; // 첫번째 document 만 가져와서 화면에 띄울 것임
              final peerKey = firstDocument.data['userKey'].toString();

              return StreamBuilder<User>(
                stream: firestoreProvider.connectUser(peerKey),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // 상대 계정 삭제 등 invalid userKey 일 경우
                    return InvalidCard();
                  }
                  return MyQuestionsCard(
                    myQuestion: firstDocument.data['question'].toString(),
                    peerAnswer: firstDocument.data['answer'].toString(),
                    documentId: firstDocument.documentID,
                    peer: snapshot.data,
                  );
                },
              );
            },
          ),
        ),
      );
    });
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
