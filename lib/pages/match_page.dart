import 'package:datingapp/constants/size.dart';
import 'package:flutter/material.dart';

class MatchPage extends StatefulWidget {

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final _answerController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child: _buildAnswer(),
            ),
            Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child: FlatButton(
                child: const Text(
                  '제출하기',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  final answer = _answerController.text;
                  print(answer);
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
      decoration: _buildInputDecoration('답변'),
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
