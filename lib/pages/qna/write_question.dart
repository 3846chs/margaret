import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/balance.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/questions_example.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:provider/provider.dart';

class WriteQuestion extends StatefulWidget {
  @override
  _WriteQuestionState createState() => _WriteQuestionState();
}

class _WriteQuestionState extends State<WriteQuestion> {
  final _firestore = Firestore.instance;
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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Consumer<MyUserData>(builder: (context, myUserData, _) {
            return SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  '오늘 남은 질문 횟수: ' +
                      myUserData.userData.numMyQuestions.toString(),
                  style: TextStyle(fontFamily: FontFamily.jua),
                ),
                SizedBox(
                  height: screenAwareHeight(10, context),
                ),
                TextField(
                    controller: _questionController,
                    style: TextStyle(color: Colors.black),
                    decoration: _buildInputDecoration('가치관 질문을 입력해주세요'),
                    maxLength: MAX_RANDOM_QNA_LENGTH,
                    maxLines: 4),
                Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  height: screenAwareHeight(50, context),
                  width: double.infinity,
                  child: Text(
                    '질문을 자유롭게 작성해서 가치관 질문을 보내주세요!\n아래의 카테고리별 예시 질문도 참고해보세요.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: <Widget>[
                      MyQuestionExample(
                        questionController: _questionController,
                        iconData: FontAwesomeIcons.phoneVolume,
                        category: '연락/만남',
                        examples: contactQuestions,
                      ),
                      MyQuestionExample(
                        questionController: _questionController,
                        iconData: FontAwesomeIcons.solidHeart,
                        category: '연애관',
                        examples: datingQuestions,
                      ),
                      MyQuestionExample(
                        questionController: _questionController,
                        iconData: FontAwesomeIcons.baby,
                        category: '결혼관',
                        examples: marriageQuestions,
                      ),
                      MyQuestionExample(
                        questionController: _questionController,
                        iconData: FontAwesomeIcons.grin,
                        category: '성격/성향',
                        examples: characterQuestions,
                      ),
                      MyQuestionExample(
                        questionController: _questionController,
                        iconData: FontAwesomeIcons.seedling,
                        category: '취미',
                        examples: hobbyQuestions,
                      ),
                      MyQuestionExample(
                        questionController: _questionController,
                        iconData: FontAwesomeIcons.venusMars,
                        category: '19금',
                        examples: sexQuestions,
                      ),
                    ]),
                SizedBox(
                  height: screenAwareHeight(20, context),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_questionController.text.length <
                          MIN_RANDOM_QNA_LENGTH) {
                        simpleSnackbar(context,
                            '질문을 최소 $MIN_RANDOM_QNA_LENGTH자 이상 등록해주세요');
                        return;
                      }

                      await myUserData.userData.reference.updateData(
                          {'numMyQuestions': FieldValue.increment(-1)});

                      String question = _questionController.text;
                      String myUserKey = myUserData.userData.userKey;
                      String timestamp =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      _questionController.clear();
                      Navigator.pop(context);

                      QuerySnapshot querySnapshot = await _firestore
                          .collection(COLLECTION_USERS)
                          .orderBy('recentMatchTime', descending: true)
                          .getDocuments();

                      final myUser = await myUserData.userData.reference.get();
                      final List<String> blocks = myUser.data['blocks'] ?? [];

                      querySnapshot.documents
                          .where((doc) =>
                              (doc['gender'] != myUserData.userData.gender) &&
                              (doc.data['birthYear'] -
                                          myUserData.userData.birthYear)
                                      .abs() <=
                                  10 &&
                              !blocks.contains(doc.documentID))
                          .take(30)
                          .forEach((ds) {
                        ds.reference
                            .collection(PEERQUESTIONS)
                            .document(timestamp)
                            .setData(
                                {'question': question, 'userKey': myUserKey});
                      });
                    },
                    color: pastel_purple,
                    child: Container(
                      child: Text(
                        '제 출 하 기',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: FontFamily.jua),
                      ),
                    ),
                  ),
                ),
              ],
            ));
          }),
        ));
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
      fillColor: Colors.white60,
      filled: true,
    );
  }
}

class MyQuestionExample extends StatelessWidget {
  const MyQuestionExample({
    Key key,
    @required TextEditingController questionController,
    @required IconData iconData,
    @required String category,
    @required List<String> examples,
  })  : _questionController = questionController,
        iconData = iconData,
        category = category,
        examples = examples,
        super(key: key);

  final TextEditingController _questionController;
  final IconData iconData;
  final String category;
  final List<String> examples;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                children: ListTile.divideTiles(
                        context: context,
                        tiles: examples
                            .map((example) => GestureDetector(
                                  onTap: () {
                                    _questionController.text = example;
                                    Navigator.pop(context);
                                  },
                                  child: ListTile(
                                    title: Text(
                                      example,
                                    ),
                                  ),
                                ))
                            .toList())
                    .toList()));
      },
      child: Card(
        elevation: 5,
        color: Colors.pink[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            Icon(iconData),
            Spacer(
              flex: 1,
            ),
            Text(
              category,
              style: TextStyle(fontFamily: FontFamily.jua),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
