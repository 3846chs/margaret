import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayQuestion extends StatefulWidget {
  @override
  _TodayQuestionState createState() => _TodayQuestionState();
}

class _TodayQuestionState extends State<TodayQuestion> {
  final _answerController = TextEditingController();
  String _selected;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child: const Text(
                '오늘의 질문\n',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child:
                  _buildQuestion('연애할 때 상대방을 위해 얼마나 포기할 수 있나요? 전부를 희생할 수 있나요?'),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(hintText: '답변을 선택하세요'),
              value: _selected,
              items: ['전부 희생할 수 있다', '전부 희생할 수는 없다']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selected = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child: _buildAnswer(),
            ),
            Padding(
              padding: const EdgeInsets.all(common_gap),
              child: FlatButton(
                child: const Text(
                  '제출하기',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  final answer = _answerController.text;
                  print(answer);
                  Firestore.instance
                      .collection(COLLECTION_USERS)
                      .document(Provider.of<MyUserData>(context, listen: false)
                          .data
                          .userKey)
                      .updateData({
                    'recentMatchState': [DateTime.now(), 2]
                  });
                },
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                disabledColor: Colors.blue[100],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(String question) {
    return Text(
      question,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAnswer() {
    return TextField(
      controller: _answerController,
      style: TextStyle(color: Colors.black),
      decoration: _buildInputDecoration('선택한 이유'),
      maxLength: 100,
      maxLines: 5,
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
