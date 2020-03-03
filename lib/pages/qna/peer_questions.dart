import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:margaret/pages/qna/write_answer.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:provider/provider.dart';

class PeerQuestions extends StatelessWidget {
  String peerQuestion;
  String peerKey;
  String documentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'write_answer',
          onPressed: () {
            if (this.documentId == null) {
              simpleSnackbar(context, '질문이 더 이상 없습니다. 기다려주세요.');
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WriteAnswer(
                          peerKey: this.peerKey,
                          peerQuestion: this.peerQuestion,
                          documentId: this.documentId,
                        )));
          },
          backgroundColor: Colors.grey[100],
          child: Icon(
            Icons.edit,
            color: pastel_purple,
            size: 30,
          ),
        ),
        body: Consumer<MyUserData>(builder: (context, myUserData, _) {
          return FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection(COLLECTION_USERS)
                  .document(myUserData.userData.userKey)
                  .collection(PEERQUESTIONS)
//              .limit(1) // ???
                  .getDocuments(),
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    !snapshot.hasData ||
                    snapshot.data.documents.length == 0) return LoadingPage();

                var firstDocument =
                    snapshot.data.documents[0]; // 첫번째 document 만 가져와서 화면에 띄울 것임
                this.peerQuestion = firstDocument.data['question'];
                this.peerKey = firstDocument.data['userKey'];
                this.documentId = firstDocument.documentID;

                return StreamBuilder<User>(
                    stream: firestoreProvider.connectUser(peerKey),
                    builder: (context, snapshot) {
                      if (snapshot.data == null || !snapshot.hasData)
                        return LoadingPage();
                      User peer = snapshot.data;
                      return PeerQuestionsCard(
                          peer: peer, peerQuestion: this.peerQuestion);
                    });
              });
        }));
  }
}

class PeerQuestionsCard extends StatelessWidget {
  const PeerQuestionsCard({
    Key key,
    @required this.peer,
    @required this.peerQuestion,
  }) : super(key: key);

  final User peer;
  final String peerQuestion;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            child: ClipOval(
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: "profiles/${peer.profiles[0]}",
                    cacheManager: StorageCacheManager(),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.account_circle),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: new Container(
                      decoration:
                          new BoxDecoration(color: Colors.white.withOpacity(0.5)),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenAwareSize(10, context),
          ),
          Text(
            peer.nickname,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text('<상대 질문>'),
          Text(peerQuestion),
          SizedBox(
            height: screenAwareSize(5, context),
          ),
        ],
      ),
    );
  }
}
