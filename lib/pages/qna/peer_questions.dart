import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
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
                    documentId: this.documentId,
                    peer: peer,
                    peerQuestion: this.peerQuestion,
                  );
                });
          });
    }));
  }
}

class PeerQuestionsCard extends StatelessWidget {
  const PeerQuestionsCard({
    Key key,
    @required this.documentId,
    @required this.peer,
    @required this.peerQuestion,
  }) : super(key: key);

  final User peer;
  final String peerQuestion;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.documentId == null) {
          simpleSnackbar(context, '질문이 더 이상 없습니다. 기다려주세요.');
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WriteAnswer(
                      peerKey: this.peer.userKey,
                      peerQuestion: this.peerQuestion,
                      documentId: this.documentId,
                    )));
      },
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print('삭제하기');
                },
                child: Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Icon(
                    FontAwesomeIcons.solidTrashAlt,
                    color: Colors.pink[200],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(48.0),
                    boxShadow: [
                      new BoxShadow(color: Colors.grey, blurRadius: 5.0)
                    ]),
                child: CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: "profiles/${this.peer.profiles[0]}",
                          cacheManager: StorageCacheManager(),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.account_circle),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                          child: new Container(
                            decoration: new BoxDecoration(
                                color: Colors.white.withOpacity(0.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Column(
                children: <Widget>[
                  Text(
                    this.peer.nickname,
                    style: TextStyle(fontFamily: FontFamily.jua, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    (DateTime.now().year - this.peer.birthYear + 1).toString() +
                        '세 / ' +
                        this.peer.region,
                    style: TextStyle(fontFamily: FontFamily.jua, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: screenAwareSize(10, context),
          ),
          Container(
              alignment: Alignment(-0.8, 0),
              child: Icon(
                FontAwesomeIcons.quoteLeft,
                size: 15,
                color: Colors.purple[100],
              )),
          Container(
            width: 250,
            child: Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Center(
                child: Text(
                  this.peer.introduction ?? '등록된 자기소개가 없습니다',
                  style: TextStyle(
                      fontFamily: FontFamily.nanumBarunpen,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
              alignment: Alignment(0.8, 0),
              child: Icon(
                FontAwesomeIcons.quoteRight,
                size: 15,
                color: Colors.purple[100],
              )),
          SizedBox(
            height: screenAwareSize(10, context),
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.all(common_gap),
                child: Center(
                    child: Text(
                  peerQuestion,
                  style: TextStyle(
                    fontFamily: FontFamily.miSaeng,
                    fontSize: 25,
                  ),
                )),
              ),
              width: 270,
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.pink[100],
                    Colors.white,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(7.0, 7.0), // shadow direction: bottom right
                  )
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              )),
        ],
      ),
    );
  }
}
