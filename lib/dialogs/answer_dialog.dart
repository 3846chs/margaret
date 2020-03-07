import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:provider/provider.dart';

class AnswerDialog extends StatefulWidget {
  final String peerKey;
  final String peerQuestion;
  final String documentId;

  AnswerDialog(
      {@required this.peerKey,
      @required this.peerQuestion,
      @required this.documentId});

  @override
  _AnswerDialogState createState() => _AnswerDialogState();
}

class _AnswerDialogState extends State<AnswerDialog> {
  final _firestore = Firestore.instance;
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _sendAnswer(User myUser) async {
    await myUser.reference
        .collection(PEERQUESTIONS)
        .document(widget.documentId)
        .delete();
    // 해당 질문 PeerQuestions 에서 삭제
    _firestore
        .collection(COLLECTION_USERS)
        .document(widget.peerKey)
        .collection(MYQUESTIONS)
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData({
      'question': widget.peerQuestion,
      'answer': _answerController.text,
      'userKey': myUser.userKey
    });
    // 내 답변 Peer 에게 전송
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final myUserData = Provider.of<MyUserData>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.peerQuestion),
            TextField(
              controller: _answerController,
              style: TextStyle(color: Colors.black),
              decoration: _buildInputDecoration('답변을 입력해주세요'),
              maxLength: 100,
              maxLines: 5,
            ),
            FlatButton(
              onPressed: () => _sendAnswer(myUserData.userData),
              child: const Icon(
                Icons.check,
                size: 50,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
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
