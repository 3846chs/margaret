import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/widgets/qna/empty_my_questions_card.dart';
import 'package:margaret/widgets/qna/my_questions_card.dart';
import 'package:provider/provider.dart';

class MyQuestions extends StatelessWidget {
  final _firestore = Firestore.instance;

  Future<DocumentSnapshot> _getFirstDocument(
      List<DocumentSnapshot> documents) async {
    for (final doc in documents) {
      final userDocument = await _firestore
          .collection(COLLECTION_USERS)
          .document(doc.documentID)
          .get();

      if (userDocument != null && userDocument.exists) return doc;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(builder: (context, myUserData, _) {
      return Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: StreamBuilder<QuerySnapshot>(
            stream: myUserData.userData.reference
                .collection(MYQUESTIONS)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0)
                return EmptyMyQuestionsCard();

              return FutureBuilder<DocumentSnapshot>(
                future: _getFirstDocument(snapshot.data.documents),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final firstDocument = snapshot.data;
                  final peerKey = firstDocument.data['userKey'].toString();

                  return StreamBuilder<User>(
                    stream: firestoreProvider.connectUser(peerKey),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
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
              );
            },
          ),
        ),
      );
    });
  }
}
