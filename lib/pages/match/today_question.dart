import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:margaret/utils/prefs_provider.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodayQuestion extends StatefulWidget {
  @override
  _TodayQuestionState createState() => _TodayQuestionState();
}

class _TodayQuestionState extends State<TodayQuestion>
    with WidgetsBindingObserver {
  final _firestore = Firestore.instance;
  final _answerController = TextEditingController();
  String _selected;
  int _selectedIndex = -1;
  String _userKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _answerController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    prefsProvider.initialize().then((_) {
      if (_userKey != null) {
        if (state != AppLifecycleState.resumed) {
          prefsProvider.setAnswer(_userKey, _answerController.text);
        } else {
          if (_answerController != null)
            _answerController.text = prefsProvider.getAnswer(_userKey);
        }
      }
    });
  }

  Future<void> _summit(User user, String question) async {
    final answer = _answerController.text;

    if (_selectedIndex == -1) {
      simpleSnackbar(context, '선택지를 골라주세요');
      return;
    }

    if (answer.length < 10) {
      simpleSnackbar(context, '답변이 너무 짧습니다');
      return;
    }

    _answerController.clear();

    user.reference.updateData({
      'exposed': 0,
      'answer': answer,
    }); // 유저 field 에 답변 저장(your_profile 에서 꺼내기 용이하게 하려고)

    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');

    user.reference
        .collection('TodayQuestions')
        .document(formatter.format(user.recentMatchTime.toDate()))
        .setData({
      'question': question,
      'choice': _selected,
      'answer': answer,
    }); // recentMatchTime 을 이용하여 유저 답변 DB 에 저장

    if (now.hour == 23 && now.minute == 59 && now.second > 50) {
      simpleSnackbar(context, '자정까지 10초 미만 남았습니다. 이 경우, 제출되지 않습니다.');
      return;
    } else {
      user.reference.updateData({
        'recentMatchState': _selectedIndex + 1
      }); // 1번 선택했으면 1 저장, 2번 선택했으면 2 저장
    }

    _firestore
        .collection(TODAYQUESTIONS)
        .document(formatter.format(now))
        .updateData({
      'unmatchedList': FieldValue.arrayUnion([user.userKey])
    });

    DocumentSnapshot ds = await _firestore
        .collection(TODAYQUESTIONS)
        .document(formatter.format(now))
        .get();

    ds.data['unmatchedList'].forEach((unmatchedUserKey) async {
      // unmatchedUserKey 가 (계정 삭제 등으로 인해) invalid 할 수도 있음 => 에러남 -> 나중에 처리
      List<String> recommendedPeople = await matchUser(unmatchedUserKey);

      if (recommendedPeople.length >= 3) {
        // first, second, third 를 추천해주고, 세 사람에게는 exposed++ 를 해준다.
        _firestore
            .collection(COLLECTION_USERS)
            .document(unmatchedUserKey)
            .collection(TODAYQUESTIONS)
            .document(formatter.format(now))
            .updateData(
                {'recommendedPeople': recommendedPeople.take(3).toList()});
        _firestore
            .collection(COLLECTION_USERS)
            .document(recommendedPeople[0])
            .updateData({'exposed': FieldValue.increment(1)});
        _firestore
            .collection(COLLECTION_USERS)
            .document(recommendedPeople[1])
            .updateData({'exposed': FieldValue.increment(1)});
        _firestore
            .collection(COLLECTION_USERS)
            .document(recommendedPeople[2])
            .updateData({'exposed': FieldValue.increment(1)});

        _firestore
            .collection(TODAYQUESTIONS)
            .document(formatter.format(now))
            .updateData({
          'unmatchedList': FieldValue.arrayRemove([unmatchedUserKey])
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore
          .collection(TODAYQUESTIONS)
          .document(formattedDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoadingPage();

        final choiceList = [
          snapshot.data.data['choice1'].toString(),
          snapshot.data.data['choice2'].toString()
        ];

        return _buildBody(snapshot.data.data['question'], choiceList);
      },
    );
  }

  Widget _buildBody(String question, List<String> choiceList) {
    final myUser = Provider.of<MyUserData>(context, listen: false).userData;

    if (_userKey == null) {
      _userKey = myUser.userKey;

      prefsProvider.initialize().then((_) {
        _answerController.text = prefsProvider.getAnswer(_userKey);
      });
    }

    return Stack(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(common_l_gap),
                  child: _buildQuestion(question),
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
                SizedBox(height: screenAwareSize(90, context)),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 50,
          child: SizedBox(
            height: 50,
            child: RaisedButton(
              onPressed: () => _summit(myUser, question),
              color: pastel_purple,
              child: Container(
                child: Text(
                  '제 출 하 기',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: FontFamily.jua,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion(String question) {
    return Text(
      question,
      textAlign: TextAlign.center,
      style: TextStyle(fontFamily: 'BMJUA', fontSize: 20),
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

  Future<List<String>> matchUser(String userKey) async {
    final ls = <String>[];
    final ds =
        await _firestore.collection(COLLECTION_USERS).document(userKey).get();

    final querySnapshot = await _firestore
        .collection(COLLECTION_USERS)
//        .where('gender', isEqualTo: ds.data['gender'] == '남성' ? '여성' : '남성')
//        .where('recentMatchState', isEqualTo: ds.data['recentMatchState'])
        .orderBy('exposed', descending: false)
        .getDocuments();

    final now = DateTime.now();
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
