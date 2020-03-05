import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/dialogs/question_dialog.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:margaret/widgets/qna/my_questions_card.dart';
import 'package:provider/provider.dart';

class MyQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      body: Consumer<MyUserData>(
        builder: (context, myUserData, _) {
          return FutureBuilder<QuerySnapshot>(
            future: myUserData.userData.reference
                .collection(MYQUESTIONS)
//              .limit(1) // ???
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0)
                return LoadingPage();

              final firstDocument = snapshot
                  .data.documents.first; // 첫번째 document 만 가져와서 화면에 띄울 것임
              final peerKey = firstDocument.data['userKey'].toString();

              return StreamBuilder<User>(
                stream: firestoreProvider.connectUser(peerKey),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LoadingPage();
                  return MyQuestionsCard(
                    myQuestion: firstDocument.data['question'].toString(),
                    peerAnswer: firstDocument.data['answer'].toString(),
                    documentId: firstDocument.documentID,
                    peer: snapshot.data,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'write_question',
      onPressed: () {
        showDialog(context: context, builder: (context) => QuestionDialog());
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
