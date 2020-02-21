import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/colors.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/firebase/storage_provider.dart';
import 'package:datingapp/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TempProfileInput extends StatefulWidget {
  final AuthResult authResult;

  TempProfileInput({@required this.authResult});

  @override
  _TempProfileInputState createState() => _TempProfileInputState();
}

class _TempProfileInputState extends State<TempProfileInput> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _birthYearController = TextEditingController();
  final _regionController = TextEditingController();
  final _jobController = TextEditingController();
  final _heightController = TextEditingController();

  List<File> _profiles = [];

  List<bool> _genderSelected = [true, false];

  Future<void> _getProfile() async {
    if (_profiles.length >= 2) return;

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
        _profiles.add(image);
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
                            : Image.file(
                                _profiles[0],
                                height: 300,
                                width: 300,
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
                            : Image.file(
                                _profiles[1],
                                height: 300,
                                width: 300,
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
                Builder(
                  builder: (context) => FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate() &&
                          _profiles.length > 0) _register(context);
                    },
                    child: Text("가입하기", style: TextStyle(color: Colors.white)),
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
    try {
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
          recentMatchTime: Timestamp.now(),
          recentMatchState: 0,
          chats: [],
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
