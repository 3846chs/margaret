import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:margaret/pages/qna/write_question.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:provider/provider.dart';

class MyQuestions extends StatelessWidget {
  String myQuestion;
  String peerAnswer;
  String peerKey;
  String documentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'write_question',
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => WriteQuestion()));
        },
        backgroundColor: Colors.grey[100],
        child: Icon(
          Icons.add,
          color: pastel_purple,
          size: 30,
        ),
      ),
      body: Consumer<MyUserData>(builder: (context, myUserData, _) {
        return FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection(COLLECTION_USERS)
                .document(myUserData.userData.userKey)
                .collection(MYQUESTIONS)
//              .limit(1) // ???
                .getDocuments(),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  !snapshot.hasData ||
                  snapshot.data.documents.length == 0) return LoadingPage();

              var firstDocument =
                  snapshot.data.documents[0]; // 첫번째 document 만 가져와서 화면에 띄울 것임
              this.myQuestion = firstDocument.data['question'];
              this.peerAnswer = firstDocument.data['answer'];
              this.peerKey = firstDocument.data['userKey'];
              this.documentId = firstDocument.documentID;

              return StreamBuilder<User>(
                  stream: firestoreProvider.connectUser(peerKey),
                  builder: (context, snapshot) {
                    if (snapshot.data == null || !snapshot.hasData)
                      return LoadingPage();
                    User peer = snapshot.data;
                    return MyQuestionsCard(
                      myQuestion: this.myQuestion,
                      peerAnswer: this.peerAnswer,
                      documentId: this.documentId,
                      peer: peer,
                    );
                  });
            });
      }),
    );
  }
}

class MyQuestionsCard extends StatelessWidget {
  const MyQuestionsCard({
    Key key,
    @required this.myQuestion,
    @required this.peerAnswer,
    @required this.documentId,
    @required this.peer,
  }) : super(key: key);

  final String myQuestion;
  final String peerAnswer;
  final String documentId;
  final User peer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print('패스하기');
            },
            child: Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.solidTrashAlt,
                    color: Colors.pink[200],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
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
              padding: const EdgeInsets.all(8.0),
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
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      this.peerAnswer,
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
                        offset:
                            Offset(7.0, 7.0), // shadow direction: bottom right
                      )
                    ],
//                    border: Border.all(color: Colors.pink[100], width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
