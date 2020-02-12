import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firestore/firestore_provider.dart';
import 'package:datingapp/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfileInputPage extends StatefulWidget {
  final String email;
  final String password;

  ProfileInputPage({@required this.email, @required this.password});

  @override
  _ProfileInputPageState createState() => _ProfileInputPageState();
}

class _ProfileInputPageState extends State<ProfileInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _birthYearController = TextEditingController();
  final _regionController = TextEditingController();
  final _jobController = TextEditingController();
  final _heightController = TextEditingController();

  List<bool> _genderSelected = [true, false];

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthYearController.dispose();
    _regionController.dispose();
    _jobController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: common_l_gap,
                ),
                TextFormField(
                  controller: _nicknameController,
                  decoration: getTextFieldDecor('닉네임'),
                  validator: (value) {
                    if (value.isEmpty) return '닉네임을 입력해주세요!';
                    return null;
                  },
                ),
                SizedBox(
                  height: common_l_gap,
                ),
                ToggleButtons(
                  children: const [
                    Text('남성'),
                    Text('여성'),
                  ],
                  onPressed: (index) {
                    setState(() {
                      switch (index) {
                        case 0:
                          _genderSelected[0] = true;
                          _genderSelected[1] = false;
                          break;
                        case 1:
                          _genderSelected[0] = false;
                          _genderSelected[1] = true;
                          break;
                      }
                    });
                  },
                  isSelected: _genderSelected,
                ),
                SizedBox(
                  height: common_l_gap,
                ),
                TextFormField(
                  controller: _birthYearController,
                  decoration: getTextFieldDecor('출생 연도'),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) return '출생 연도 4자리를 입력해주세요!';
                    return null;
                  },
                ),
                SizedBox(
                  height: common_l_gap,
                ),
                TextFormField(
                  controller: _regionController,
                  decoration: getTextFieldDecor('지역'),
                  validator: (value) {
                    if (value.isEmpty) return '사는 지역을 입력해주세요!';
                    return null;
                  },
                ),
                SizedBox(
                  height: common_l_gap,
                ),
                TextFormField(
                  controller: _jobController,
                  decoration: getTextFieldDecor('직업'),
                  validator: (value) {
                    if (value.isEmpty) return '직업을 입력해주세요!';
                    return null;
                  },
                ),
                SizedBox(
                  height: common_l_gap,
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: getTextFieldDecor('키'),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) return '키를 입력해주세요!';
                    return null;
                  },
                ),
                SizedBox(
                  height: common_l_gap,
                ),
                Builder(
                  builder: (context) => FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) _register(context);
                    },
                    child: Text("가입하기", style: TextStyle(color: Colors.white)),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    disabledColor: Colors.blue[100],
                  ),
                ),
                SizedBox(
                  height: common_l_gap,
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email, password: widget.password);

      if (result.user == null) {
        simpleSnackbar(context, 'Please try again later!');
      } else {
        final user = User(
          userKey: result.user.uid,
          email: result.user.email,
          nickname: _nicknameController.text,
          gender: _genderSelected[0] ? '남성' : '여성',
          birthYear: int.parse(_birthYearController.text),
          region: _regionController.text,
          job: _jobController.text,
          height: int.parse(_heightController.text),
          recentMatchTime: Timestamp.now(),
          recentMatchState: 0,
        );

        await firestoreProvider.attemptCreateUser(user);

        Provider.of<MyUserData>(context, listen: false)
            .setNewStatus(MyUserDataStatus.progress);
        Navigator.pop(context);

      }
    } on PlatformException catch (exception) {
      simpleSnackbar(context, exception.message);
    }
  }

  InputDecoration getTextFieldDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: Colors.grey[100],
      filled: true,
    );
  }
}
