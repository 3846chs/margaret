import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/utils/simple_snack_bar.dart';
import 'package:datingapp/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodayQuestion extends StatefulWidget {
  @override
  _TodayQuestionState createState() => _TodayQuestionState();
}

class _TodayQuestionState extends State<TodayQuestion> {
  final _answerController = TextEditingController();
  String _selected;
  int _selectedIndex = -1;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: myStream(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return LoadingPage();
          else if (!snapshot.hasData)
            return LoadingPage(); // 질문 리스트가 준비돼있지 않을 경우
          else {
            List<String> choice_list = [
              snapshot.data.data['choice1'].toString(),
              snapshot.data.data['choice2'].toString()
            ];
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(common_gap),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(common_l_gap),
                          child: _buildQuestion(snapshot.data.data['question']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(common_gap),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(hintText: '답변을 선택하세요'),
                            value: _selected,
                            items: choice_list
                                .map((label) => DropdownMenuItem(
                                      child: Text(label),
                                      value: label,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selected = value;
                                _selectedIndex = choice_list.indexOf(value);
                                print(_selectedIndex);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(common_gap),
                          child: _buildAnswer(),
                        ),
                        Consumer<MyUserData>(builder: (context, value, child) {
                          return FloatingActionButton(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            child: Icon(
                              Icons.send,
                            ),
                            onPressed: () {
                              final answer = _answerController.text;

                              if (_selectedIndex == -1) {
                                simpleSnackbar(context, '선택지를 골라주세요');
                                return;
                              } else if (answer.length < 10) {
                                simpleSnackbar(context, '답변이 너무 짧습니다');
                                return;
                              } else {
                                DocumentReference userRef = Firestore.instance
                                    .collection(COLLECTION_USERS)
                                    .document(value.userData.userKey);

                                var now = DateTime.now();
                                var formatter = DateFormat('yyyy-MM-dd');


                                // 23시 59분 59초에 유저가 답변을 제출하면, 시간 지연으로 인해 다음 날 답변으로 기록되는 현상 발생 -> 아래와 같이 해결
                                if (now.day ==
                                    value.userData.recentMatchTime
                                        .toDate()
                                        .day) {
                                  userRef
                                      .collection('TodayQuestions')
                                      .document(formatter.format(now))
                                      .setData({
                                    'question': snapshot.data.data['question'],
                                    'choice': _selected,
                                    'answer': answer
                                  }); // 유저 답변 DB 에 저장
                                  userRef.updateData(
                                      {'recentMatchTime': now}); // 답변한 시각 저장
                                  userRef.updateData({
                                    'recentMatchState': _selectedIndex + 1
                                  }); // 1번 선택했으면 1 저장, 2번 선택했으면 2 저장
                                } else {
                                  print('시간 지연 발생');
                                  userRef
                                      .collection('TodayQuestions')
                                      .document(formatter.format(value
                                          .userData.recentMatchTime
                                          .toDate()))
                                      .setData({
                                    'question': snapshot.data.data['question'],
                                    'choice': _selected,
                                    'answer': answer
                                  });
                                  // recentMatchTime 을 이용하여 유저 답변만 DB 에 저장
                                }
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  Stream<DocumentSnapshot> myStream() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    return Firestore.instance
        .collection(TODAYQUESTIONS)
        .document(formattedDate)
        .snapshots();
  }

  Widget _buildQuestion(String question) {
    return Text(
      question,
      textAlign: TextAlign.center,
      style: GoogleFonts.jua(
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
        maxLines: 5);
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
