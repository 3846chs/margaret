import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileInputPage extends StatefulWidget {
  final AuthResult authResult;

  ProfileInputPage({@required this.authResult});

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
  final _smokeController = TextEditingController();
  final _drinkController = TextEditingController();
  final _religionController = TextEditingController();
  final _introductionController = TextEditingController();

  List<File> _profiles = [];

  List<bool> _genderSelected = [true, false];

  bool _isButtonEnabled = true;

  Future<void> _getProfile([int index]) async {
    if (_profiles.length >= 2 && index == null) return;

    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    image = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(
        ratioX: 1.0,
        ratioY: 1.0,
      ),
    );

    if (image != null) {
      setState(() {
        if (index == null)
          _profiles.add(image);
        else
          _profiles[index] = image;
      });
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthYearController.dispose();
    _regionController.dispose();
    _jobController.dispose();
    _heightController.dispose();
    _smokeController.dispose();
    _drinkController.dispose();
    _religionController.dispose();
    _introductionController.dispose();
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
                const SizedBox(height: common_l_gap),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(common_gap),
                        child: _profiles.length < 1
                            ? SizedBox(
                                width: 150,
                                height: 150,
                                child: RaisedButton(
                                  child: const Icon(Icons.add_a_photo),
                                  onPressed: _getProfile,
                                ),
                              )
                            : FlatButton(
                                onPressed: () => _getProfile(0),
                                child: Image.file(
                                  _profiles[0],
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(common_gap),
                        child: _profiles.length < 2
                            ? SizedBox(
                                width: 150,
                                height: 150,
                                child: RaisedButton(
                                  child: const Icon(Icons.add_a_photo),
                                  onPressed: _getProfile,
                                ),
                              )
                            : FlatButton(
                                onPressed: () => _getProfile(1),
                                child: Image.file(
                                  _profiles[1],
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                TextFormField(
                  controller: _nicknameController,
                  decoration: getTextFieldDecor('닉네임'),
                  validator: (value) {
                    if (value.isEmpty) return '닉네임을 입력해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: common_l_gap),
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
                const SizedBox(height: common_l_gap),
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
                const SizedBox(height: common_l_gap),
                TextFormField(
                  controller: _regionController,
                  decoration: getTextFieldDecor('지역'),
                  validator: (value) {
                    if (value.isEmpty) return '사는 지역을 입력해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: common_l_gap),
                TextFormField(
                  controller: _jobController,
                  decoration: getTextFieldDecor('직업'),
                  validator: (value) {
                    if (value.isEmpty) return '직업을 입력해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: common_l_gap),
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
                const SizedBox(height: common_l_gap),
                TextFormField(
                  controller: _smokeController,
                  decoration: getTextFieldDecor('흡연 여부'),
                  validator: (value) {
                    if (value.isEmpty) return '흡연 여부를 선택해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: common_l_gap),
                TextFormField(
                  controller: _drinkController,
                  decoration: getTextFieldDecor('음주 여부'),
                  validator: (value) {
                    if (value.isEmpty) return '음주 여부를 선택해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: common_l_gap),
                TextFormField(
                  controller: _religionController,
                  decoration: getTextFieldDecor('종교'),
                  validator: (value) {
                    if (value.isEmpty) return '종교를 선택해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: common_l_gap),
                TextFormField(
                  controller: _introductionController,
                  decoration: getTextFieldDecor('나의 가치관을 나타낼 수 있는 자기소개를 해주세요'),
                  validator: (value) {
                    if (value.isEmpty) return '자기소개를 입력해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: common_l_gap),
                Builder(
                  builder: (context) => FlatButton(
                    onPressed: !_isButtonEnabled
                        ? null
                        : () {
                            if (_formKey.currentState.validate() &&
                                _profiles.length > 0) {
                              setState(() {
                                _isButtonEnabled = false;
                              });
                              _register(context);
                            }
                          },
                    child: _isButtonEnabled
                        ? Text(
                            "가입하기",
                            style: TextStyle(color: Colors.white),
                          )
                        : const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black87),
                          ),
                    color: pastel_purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: common_l_gap),
              ],
            )),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (widget.authResult.user == null) {
      simpleSnackbar(context, 'Please try again later!');
    } else {
      final profiles = await Stream.fromIterable(_profiles)
          .asyncMap((image) => storageProvider.uploadImg(image,
              "profiles/${DateTime.now().millisecondsSinceEpoch}_${widget.authResult.user.uid}"))
          .toList();
      final user = User(
        userKey: widget.authResult.user.uid,
        profiles: profiles.map((image) => image.substring(9)).toList(),
        email: widget.authResult.user.email,
        nickname: _nicknameController.text,
        gender: _genderSelected[0] ? '남성' : '여성',
        birthYear: int.parse(_birthYearController.text),
        region: _regionController.text,
        job: _jobController.text,
        height: int.parse(_heightController.text),
        smoke: _smokeController.text,
        drink: _drinkController.text,
        religion: _religionController.text,
        introduction: _introductionController.text,
        recentMatchTime: Timestamp.now(),
        recentMatchState: MatchState.QUESTION,
        exposed: 0,
        chats: [],
      );

      await firestoreProvider.attemptCreateUser(user);

      Provider.of<MyUserData>(context, listen: false)
          .setNewStatus(MyUserDataStatus.progress);
      Navigator.pop(context);
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
