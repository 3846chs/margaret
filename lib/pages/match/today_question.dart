import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
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
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection(TODAYQUESTIONS)
          .document(formattedDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null || !snapshot.hasData) return LoadingPage();

        List<String> choiceList = [
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
                        items: choiceList
                            .map((label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selected = value;
                            _selectedIndex = choiceList.indexOf(value);
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
                        onPressed: () async {
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

                            userRef.updateData({'exposed': 0});
                            userRef.updateData({
                              'answer': answer
                            }); // 유저 field 에 답변 저장(your_profile 에서 꺼내기 용이하게 하려고)

                            var now = DateTime.now();
                            var formatter = DateFormat('yyyy-MM-dd');

                            // 23시 59분 59초에 유저가 답변을 제출하면, 시간 지연으로 인해 다음 날 답변으로 기록되는 현상 발생 -> 아래와 같이 해결
                            if (now.day ==
                                value.userData.recentMatchTime.toDate().day) {
                              userRef
                                  .collection('TodayQuestions')
                                  .document(formatter.format(now))
                                  .setData({
                                'question': snapshot.data.data['question'],
                                'choice': _selected,
                                'answer': answer
                              }); // 유저 답변 DB 에 저장

                              userRef.updateData({
                                'recentMatchState': _selectedIndex + 1
                              }); // 1번 선택했으면 1 저장, 2번 선택했으면 2 저장
                            } else {
                              print('시간 지연 발생');
                              userRef
                                  .collection('TodayQuestions')
                                  .document(formatter.format(
                                      value.userData.recentMatchTime.toDate()))
                                  .setData({
                                'question': snapshot.data.data['question'],
                                'choice': _selected,
                                'answer': answer
                              });
                              // recentMatchTime 을 이용하여 유저 답변만 DB 에 저장
                            }

                            Firestore.instance
                                .collection(TODAYQUESTIONS)
                                .document(formatter.format(now))
                                .updateData({
                              'unmatchedList': FieldValue.arrayUnion(
                                  [value.userData.userKey])
                            });

                            DocumentSnapshot ds = await Firestore.instance
                                .collection(TODAYQUESTIONS)
                                .document(formatter.format(now))
                                .get();

                            ds.data['unmatchedList']
                                .forEach((unmatchedUserKey) async {
                              // unmatchedUserKey 가 (계정 삭제 등으로 인해) invalid 할 수도 있음 => 에러남 -> 나중에 처리
                              List<String> recommendedPeople =
                                  await matchUser(unmatchedUserKey);

                              if (recommendedPeople.length >= 3) {
                                // first, second, third 를 추천해주고, 세 사람에게는 exposed++ 를 해준다.
                                Firestore.instance
                                    .collection(COLLECTION_USERS)
                                    .document(unmatchedUserKey)
                                    .collection(TODAYQUESTIONS)
                                    .document(formatter.format(now))
                                    .updateData({
                                  'recommendedPeople':
                                      recommendedPeople.take(3).toList()
                                });
                                Firestore.instance
                                    .collection(COLLECTION_USERS)
                                    .document(recommendedPeople[0])
                                    .updateData(
                                        {'exposed': FieldValue.increment(1)});
                                Firestore.instance
                                    .collection(COLLECTION_USERS)
                                    .document(recommendedPeople[1])
                                    .updateData(
                                        {'exposed': FieldValue.increment(1)});
                                Firestore.instance
                                    .collection(COLLECTION_USERS)
                                    .document(recommendedPeople[2])
                                    .updateData(
                                        {'exposed': FieldValue.increment(1)});

                                Firestore.instance
                                    .collection(TODAYQUESTIONS)
                                    .document(formatter.format(now))
                                    .updateData({
                                  'unmatchedList':
                                      FieldValue.arrayRemove([unmatchedUserKey])
                                });
                              }
                            });
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
      },
    );
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

  Future<List<String>> matchUser(String userKey) async {
    List<String> ls = [];
    DocumentSnapshot ds = await Firestore.instance
        .collection(COLLECTION_USERS)
        .document(userKey)
        .get();

    final QuerySnapshot querySnapshot = await Firestore.instance
        .collection(COLLECTION_USERS)
//        .where('gender', isEqualTo: ds.data['gender'] == '남성' ? '여성' : '남성')
//        .where('recentMatchState', isEqualTo: ds.data['recentMatchState'])
        .orderBy('exposed', descending: false)
        .getDocuments();

    var now = DateTime.now();
    querySnapshot.documents
        .where((doc) => (doc['gender'] != ds.data['gender'] &&
            doc['recentMatchState'].abs() ==
                ds.data['recentMatchState'].abs() &&
            doc['recentMatchTime'].toDate().year == now.year &&
            doc['recentMatchTime'].toDate().month == now.month &&
            doc['recentMatchTime'].toDate().day == now.day))
        .forEach((e) {
      ls.add(e.documentID);
    });

    return ls;
  }
}
