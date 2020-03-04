import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:provider/provider.dart';

class WriteAnswer extends StatefulWidget {
  final String peerKey;
  final String peerQuestion;
  final String documentId;

  WriteAnswer(
      {@required this.peerKey,
      @required this.peerQuestion,
      @required this.documentId});

  @override
  _WriteAnswerState createState() => _WriteAnswerState();
}

class _WriteAnswerState extends State<WriteAnswer> {
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<MyUserData>(builder: (context, myUserData, _) {
      return SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: screenAwareSize(30, context),
            ),
            Text(widget.peerQuestion),
            TextField(
                controller: _answerController,
                style: TextStyle(color: Colors.black),
                decoration: _buildInputDecoration('답변을 입력해주세요'),
                maxLength: 100,
                maxLines: 5),
            FlatButton(
              onPressed: () async {
                await Firestore.instance
                    .collection(COLLECTION_USERS)
                    .document(myUserData.userData.userKey)
                    .collection(PEERQUESTIONS)
                    .document(widget.documentId)
                    .delete();
                // 해당 질문 PeerQuestions 에서 삭제
                Firestore.instance
                    .collection(COLLECTION_USERS)
                    .document(widget.peerKey)
                    .collection(MYQUESTIONS)
                    .document(DateTime.now().millisecondsSinceEpoch.toString())
                    .setData({
                  'question': widget.peerQuestion,
                  'answer': _answerController.text,
                  'userKey': myUserData.userData.userKey
                });
                // 내 답변 Peer 에게 전송
                Navigator.pop(context);
              },
              child: Container(
                  color: Colors.blueAccent,
                  width: 50,
                  height: 50,
                  child: Icon(Icons.check)),
            ),
          ],
        ),
      );
    }));
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.lightBlue[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.lightBlue[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: Colors.white60,
      filled: true,
    );
  }
}
