import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';

class AccountSetting extends StatelessWidget {
  AccountSetting({@required this.myUserData});

  final MyUserData myUserData;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('계정 설정'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_l_gap),
            child: GestureDetector(
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
                this.myUserData.signOutUser();
                print('로그아웃');
              },
              child: Text(
                '로그아웃',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(common_l_gap),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          title: Text('탈퇴하시겠습니까?'),
                          content: Container(
                            width: 100,
                            height: 140,
                            child: TextField(
                              maxLines: 6,
                              controller: _textEditingController,
                              decoration: _buildInputDecoration(
                                  "부족한 모습을 보여드려 대단히 죄송합니다.\n불편하셨던 점을 적어주시면 더 나은 모습으로 돌아오겠습니다.\n감사합니다."),
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () async {
                                Firestore.instance
                                    .collection(COLLECTION_STATISTICS)
                                    .document('withdrawal')
                                    .updateData({
                                  'reasons': FieldValue.arrayUnion(
                                      [_textEditingController.text])
                                });
                                _textEditingController.clear();
                                Navigator.popUntil(
                                    context, ModalRoute.withName('/'));
                                await this.myUserData.withdrawUser();
                                print('회원탈퇴');
                              },
                              child: Text(
                                '탈퇴하기',
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 15),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                '취소하기',
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 15),
                              ),
                            ),
                          ],
                        ));
              },
              child: Text(
                '회원 탈퇴',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
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
