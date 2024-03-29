import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/pages/qna/answer_dialog.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:provider/provider.dart';

class PeerQuestionsCard extends StatelessWidget {
  final User peer;
  final String peerQuestion;
  final String documentId;

  PeerQuestionsCard({
    Key key,
    @required this.documentId,
    @required this.peer,
    @required this.peerQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myUser = Provider.of<MyUserData>(context, listen: false).userData;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text('카드를 삭제하겠습니까?'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              myUser.reference
                                  .collection(PEERQUESTIONS)
                                  .document(this.documentId)
                                  .delete();
                              Navigator.pop(context);
                              print('삭제 완료');
                            },
                            child: Text(
                              '삭제만 하고 싶어요',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          FlatButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              myUser.reference.updateData({
                                "blocks": FieldValue.arrayUnion([peer.userKey]),
                              });
                              peer.reference.updateData({
                                "blocks":
                                    FieldValue.arrayUnion([myUser.userKey]),
                              });

                              (await myUser.reference
                                      .collection(PEERQUESTIONS)
                                      .where('userKey', isEqualTo: peer.userKey)
                                      .getDocuments())
                                  .documents
                                  .forEach((doc) {
                                myUser.reference
                                    .collection(PEERQUESTIONS)
                                    .document(doc.documentID)
                                    .delete();
                              }); // myUser 의 PeerQuestions 돌면서 삭제

                              (await myUser.reference
                                      .collection(MYQUESTIONS)
                                      .where('userKey', isEqualTo: peer.userKey)
                                      .getDocuments())
                                  .documents
                                  .forEach((doc) {
                                myUser.reference
                                    .collection(MYQUESTIONS)
                                    .document(doc.documentID)
                                    .delete();
                              }); // myUser 의 MyQuestions 돌면서 삭제

                              (await peer.reference
                                      .collection(PEERQUESTIONS)
                                      .where('userKey',
                                          isEqualTo: myUser.userKey)
                                      .getDocuments())
                                  .documents
                                  .forEach((doc) {
                                peer.reference
                                    .collection(PEERQUESTIONS)
                                    .document(doc.documentID)
                                    .delete();
                              }); // peer 의 PeerQuestions 돌면서 삭제

                              (await peer.reference
                                      .collection(MYQUESTIONS)
                                      .where('userKey',
                                          isEqualTo: myUser.userKey)
                                      .getDocuments())
                                  .documents
                                  .forEach((doc) {
                                peer.reference
                                    .collection(MYQUESTIONS)
                                    .document(doc.documentID)
                                    .delete();
                              }); // peer 의 MyQuestions 돌면서 삭제

                              print('차단 완료');
                            },
                            child: Text(
                              '더 이상 추천받고 싶지 않아요(차단하기)',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )));
              },
              child: Padding(
                padding: const EdgeInsets.all(common_gap),
                child: Icon(
                  FontAwesomeIcons.solidTrashAlt,
                  color: Colors.purple[200],
                ),
              ),
            ),
            SizedBox(
              width: screenAwareWidth(10, context),
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
                      FutureBuilder<String>(
                        future: storageProvider
                            .getFileURL("profiles/${peer.profiles.first}"),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: const Icon(Icons.account_circle),
                            );
                          }
                          if (!snapshot.hasData)
                            return const CircularProgressIndicator();
                          return Image.network(snapshot.data);
                        },
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
              width: screenAwareWidth(40, context),
            ),
            Column(
              children: <Widget>[
                Text(
                  this.peer.nickname,
                  style: TextStyle(
                      fontFamily: FontFamily.jua,
                      fontSize: screenAwareTextSize(14, context)),
                ),
                SizedBox(
                  height: screenAwareHeight(10, context),
                ),
                Text(
                  (DateTime.now().year - this.peer.birthYear + 1).toString() +
                      '세 / ' +
                      this.peer.region,
                  style: TextStyle(
                      fontFamily: FontFamily.jua,
                      fontSize: screenAwareTextSize(14, context)),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: screenAwareHeight(10, context),
        ),
        Container(
            alignment: Alignment(-0.8, 0),
            child: Icon(
              FontAwesomeIcons.quoteLeft,
              size: 15,
              color: Colors.purple[100],
            )),
        Container(
          width: screenAwareWidth(250, context),
          child: Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Center(
              child: Text(
                this.peer.introduction ?? '등록된 자기소개가 없습니다',
                style: TextStyle(
                    fontSize: screenAwareTextSize(11, context),
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
          height: screenAwareHeight(10, context),
        ),
        Container(
            child: Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Center(
                  child: Text(
                peerQuestion,
                style: TextStyle(
                  fontFamily: FontFamily.miSaeng,
                  fontSize: screenAwareTextSize(18, context),
                ),
              )),
            ),
            width: screenAwareWidth(270, context),
            height: screenAwareHeight(110, context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  this.peer.gender == '남성'
                      ? Colors.blue[100]
                      : Colors.pink[100],
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
        SizedBox(height: screenAwareHeight(20, context)),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AnswerDialog(
                      peerKey: peer.userKey,
                      peerQuestion: peerQuestion,
                      documentId: documentId,
                    ));
          },
          child: Container(
            width: screenAwareWidth(150, context),
            height: screenAwareHeight(40, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(128.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xfffd5c76),
                  Color(0xffff8951),
                ],
              ),
              boxShadow: [
                const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(3.0, 3.0), // shadow direction: bottom right
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.pencilAlt,
                  color: Colors.white,
                  size: screenAwareTextSize(12, context),
                ),
                Text(
                  "  답장하기",
                  style: TextStyle(
                    fontSize: screenAwareTextSize(12, context),
                    fontFamily: FontFamily.jua,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
