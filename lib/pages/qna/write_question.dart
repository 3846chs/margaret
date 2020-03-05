import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/pages/qna/radial_menu.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:provider/provider.dart';

class WriteQuestion extends StatefulWidget {
  @override
  _WriteQuestionState createState() => _WriteQuestionState();
}

class _WriteQuestionState extends State<WriteQuestion> {
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '가치관 질문',
            style: TextStyle(fontFamily: FontFamily.jua),
          ),
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: screenAwareSize(30, context),
            ),
            TextField(
                controller: _questionController,
                style: TextStyle(color: Colors.black),
                decoration: _buildInputDecoration('질문을 입력해주세요'),
                maxLength: 100,
                maxLines: 5),
            Consumer<MyUserData>(builder: (context, myUserData, _) {
              return FloatingActionButton(
                  heroTag: 'WriteQuestion',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: Icon(
                    Icons.send,
                  ),
                  onPressed: () async {
                    String question = _questionController.text;
                    String myUserKey = myUserData.userData.userKey;
                    String timestamp =
                    DateTime.now().millisecondsSinceEpoch.toString();
                    _questionController.text = '';
                    Navigator.pop(context);

                    final QuerySnapshot querySnapshot = await Firestore.instance
                        .collection(COLLECTION_USERS)
                    //                        .orderBy('recentMatchTime', descending: true)
                        .getDocuments();
                    querySnapshot.documents
                        .where((doc) => (doc['gender'] !=
                        myUserData.userData.gender)) // 차단 유저 제외 -> 나중에
                        .forEach((ds) {
                      Firestore.instance
                          .collection(COLLECTION_USERS)
                          .document(ds.documentID)
                          .collection('PeerQuestions')
                          .document(timestamp)
                          .setData(
                          {'question': question, 'userKey': myUserKey});
                    });
                  });
            }),
            SizedBox.fromSize(size: Size.fromHeight(300), child: RadialMenu()),
          ],
        )));
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
