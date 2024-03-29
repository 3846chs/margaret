import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:margaret/widgets/qna/empty_peer_questions_card.dart';
import 'package:margaret/widgets/qna/peer_questions_card.dart';
import 'package:provider/provider.dart';

class PeerQuestions extends StatelessWidget {
  final _firestore = Firestore.instance;

  Future<DocumentSnapshot> _getFirstDocument(
      List<DocumentSnapshot> documents) async {
    for (final doc in documents) {
      final userDocument = await _firestore
          .collection(COLLECTION_USERS)
          .document(doc.data['userKey'].toString())
          .get();

      if (userDocument != null && userDocument.exists)
        return doc;
      else {
        // 상대가 invalid 한 경우 삭제
        await _firestore.runTransaction((Transaction tx) async {
          await tx.delete(doc.reference);
        });
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Consumer<MyUserData>(
          builder: (context, myUserData, _) {
            return StreamBuilder<QuerySnapshot>(
              stream: myUserData.userData.reference
                  .collection(PEERQUESTIONS)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.documents.length == 0)
                  return EmptyPeerQuestionsCard();

                return FutureBuilder<DocumentSnapshot>(
                  future: _getFirstDocument(snapshot.data.documents),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingPage();
                    }

                    final firstDocument = snapshot.data;
                    final peerKey = firstDocument.data['userKey'].toString();

                    return StreamBuilder<User>(
                      stream: firestoreProvider.connectUser(peerKey),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return LoadingPage();
                        }
                        return PeerQuestionsCard(
                          documentId: firstDocument.documentID,
                          peer: snapshot.data,
                          peerQuestion:
                              firstDocument.data['question'].toString(),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
