import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:provider/provider.dart';

class QuestionDialog extends StatefulWidget {
  @override
  _QuestionDialogState createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  final _firestore = Firestore.instance;
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _sendQuestion(User myUser) async {
    QuerySnapshot snapshot = await _firestore
        .collection(COLLECTION_USERS)
        //.orderBy('recentMatchTime', descending: true) // 차단 유저 제외 -> 나중에
        .where(UserKeys.KEY_GENDER, isGreaterThan: myUser.gender)
        .getDocuments();
    if (snapshot.documents == null || snapshot.documents.length == 0) {
      snapshot = await _firestore
          .collection(COLLECTION_USERS)
          .where(UserKeys.KEY_GENDER, isLessThan: myUser.gender)
          .getDocuments();
    }

    final question = _questionController.text;
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    snapshot.documents.forEach(
      (ds) {
        ds.reference.collection(PEERQUESTIONS).document(timestamp).setData({
          'question': question,
          'userKey': myUser.userKey,
        });
      },
    );

    _questionController.clear();
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
            TextField(
              controller: _questionController,
              style: const TextStyle(color: Colors.black),
              decoration: _buildInputDecoration('질문을 입력해주세요'),
              maxLength: 100,
              maxLines: 5,
            ),
            FloatingActionButton(
              heroTag: 'WriteQuestion',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: const Icon(Icons.send),
              onPressed: () => _sendQuestion(myUserData.userData),
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
