import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/balance.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/utils/adjust_size.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _sendAnswer(User myUser) async {
    final now = DateTime.now();
    await myUser.reference
        .collection(PEERQUESTIONS)
        .document(widget.documentId)
        .delete();
    // 해당 질문 PeerQuestions 에서 삭제
    _firestore
        .collection(COLLECTION_USERS)
        .document(widget.peerKey)
        .collection(MYQUESTIONS)
        .document(now.millisecondsSinceEpoch.toString())
        .setData({
      'question': widget.peerQuestion,
      'answer': _answerController.text,
      'userKey': myUser.userKey
    });
    // 내 답변 Peer 에게 전송

    firestoreProvider.updateUser(myUser.userKey, {
      UserKeys.KEY_RECENTMATCHTIME: now,
    }); // 활동 이력 업데이트

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final myUserData = Provider.of<MyUserData>(context, listen: false);

    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: screenAwareHeight(20, context),
                ),
                Text(
                  widget.peerQuestion,
                  style: TextStyle(fontFamily: FontFamily.jua, fontSize: 20),
                ),
                SizedBox(
                  height: screenAwareHeight(20, context),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.length < MIN_RANDOM_QNA_LENGTH)
                      return '최소 $MIN_RANDOM_QNA_LENGTH자 이상 작성해주세요';
                    else
                      return null;
                  },
                  controller: _answerController,
                  style: TextStyle(color: Colors.black),
                  decoration: _buildInputDecoration('답변을 입력해주세요'),
                  maxLength: MAX_RANDOM_QNA_LENGTH,
                  maxLines: 4,
                ),
                FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate())
                      _sendAnswer(myUserData.userData);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(128.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
//                          Colors.purple[400],
//                          pastel_purple,
                          Color(0xfffd5c76),
                          Color(0xffff8951),
                        ],
                      ),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              3.0, 3.0), // shadow direction: bottom right
                        ),
                      ],
                    ),
                    width: screenAwareWidth(130, context),
                    height: screenAwareHeight(40, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.pencilAlt,
                          size: 17,
                          color: Colors.white,
                        ),
                        Text(
                          '  제출하기',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.jua,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.purple[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.purple[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.purple[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: Colors.white60,
      filled: true,
    );
  }
}
