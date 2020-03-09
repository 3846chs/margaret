import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
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

  List<File> _profiles = [];

  List<bool> _genderSelected = [true, false];

  bool _isButtonEnabled = true;

  String smokeinput = '흡연 여부를 선택해주세요';
  String drinkinput = '음주 여부를 선택해주세요';
  String religioninput = '종교를 선택해주세요';

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
                Container(
                  height: 30,
                  width: double.infinity,
                  color: pastel_purple,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Center(
                        child: Text('마가렛 가입을 환영합니다',
                          style: TextStyle(fontFamily: FontFamily.nanumBarunpen, color: Colors.white),),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: common_gap,),
                Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Center(
                      child: Text(
                        '사진 등록',
                        style: TextStyle(
                            fontFamily: FontFamily.nanumBarunpen,
                            color: Colors.grey),
                      )),
                ),
                SizedBox(height: common_gap,),
                Center(
                  child: SingleChildScrollView(
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
                ),
                //SizedBox(height: common_s_gap),
                Padding(
                  padding: const EdgeInsets.all(common_s_gap),
                  child: Center(child: Text('사진 2개를 등록해주세요', style: TextStyle(fontSize: 15, fontFamily: FontFamily.nanumBarunpen,
                      color: _profiles.length == 2 ? Colors.grey : Colors.redAccent),)),
                ),
                const SizedBox(height: common_l_gap),
                Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Center(
                      child: Text(
                        '기본 정보 등록',
                        style: TextStyle(
                            fontFamily: FontFamily.nanumBarunpen,
                            color: Colors.grey),
                      )),
                ),
                const SizedBox(height: common_gap,),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.user,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '닉네임',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          controller: _nicknameController,
                          decoration: getTextFieldDecor('닉네임을 입력해주세요',),
                          validator: (value) {
                            if (value.isEmpty) {return '닉네임을 입력해주세요!';} else if (value.length > 6) {return '닉네임은 6자리 이내로 해주세요';}
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.venusMars,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '성별',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: ToggleButtons(
                          children: [
                            Text('남성', style: TextStyle(color: _genderSelected[0] == true ? Colors.blue : Colors.black12),),
                            Text('여성', style: TextStyle(color: _genderSelected[1] == true ? Colors.blue : Colors.black12),),
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.birthdayCake,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '출생 연도',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          controller: _birthYearController,
                          decoration: getTextFieldDecor('출생 연도를 입력해주세요'),
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) return '출생 연도 4자리를 입력해주세요!';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.mapMarked,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '지역',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          controller: _regionController,
                          decoration: getTextFieldDecor('사는 지역을 입력해주세요'),
                          validator: (value) {
                            if (value.isEmpty) return '사는 지역을 입력해주세요!';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.suitcase,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '직업',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          controller: _jobController,
                          decoration: getTextFieldDecor('직업을 입력해주세요'),
                          validator: (value) {
                            if (value.isEmpty) return '직업을 입력해주세요!';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.child,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '키',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: getTextFieldDecor('키'),
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) return '키를 입력해주세요!';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.smoking,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '흡연 여부',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Expanded(
                                child: InkWell(
                                  child: Text('$smokeinput', style: TextStyle(color: Colors.black38, fontSize: 16)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height: 600,
                                            child: _buildSmokeDialog(context)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.beer,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '음주 여부',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Expanded(
                                child: InkWell(
                                  child: Text('$drinkinput', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height: 600,
                                            child: _buildDrinkDialog(context)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                const SizedBox(height: common_l_gap),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Icon(
                        FontAwesomeIcons.pray,
                        color: Color.fromRGBO(222, 222, 255, 1),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 70,
                        child: Center(
                          child: Text(
                            '종교',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Expanded(
                                child: InkWell(
                                  child: Text('$religioninput', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height: 600,
                                            child: _buildReligionDialog(context)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
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
        smoke: smokeinput,
        drink: drinkinput,
        religion: religioninput,
        recentMatchTime: Timestamp.now(),
        recentMatchState: MatchState.QUESTION,
        exposed: 0,
        chats: [],
      );

      await firestoreProvider.attemptCreateUser(user);

      Provider.of<MyUserData>(context, listen: false).update();
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

  SimpleDialog _buildSmokeDialog(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        _smokeSimpleDialogOption(context, '흡연'),
        _smokeSimpleDialogOption(context, '비흡연'),
      ],
    );
  }

  SimpleDialogOption _smokeSimpleDialogOption(BuildContext context, String s) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          smokeinput = s;
        });
      },
      child: Center(child: Text('$s'),),
    );
  }

  SimpleDialog _buildDrinkDialog(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        _drinkSimpleDialogOption(context, '전혀 마시지 않음'),
        _drinkSimpleDialogOption(context, '아주 가끔 마심'),
        _drinkSimpleDialogOption(context, '가끔 마심'),
        _drinkSimpleDialogOption(context, '즐기는 편'),
        _drinkSimpleDialogOption(context, '술자리 자주 있음'),
      ],
    );
  }

  SimpleDialogOption _drinkSimpleDialogOption(BuildContext context, String s) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          drinkinput = s;
        });
      },
      child: Center(child: Text('$s'),) ,
    );
  }

  _buildReligionDialog(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        _religionSimpleDialogOption(context, '없음'),
        _religionSimpleDialogOption(context, '기독교'),
        _religionSimpleDialogOption(context, '천주교'),
        _religionSimpleDialogOption(context, '불교'),
        _religionSimpleDialogOption(context, '원불교'),
        _religionSimpleDialogOption(context, '유교'),
        _religionSimpleDialogOption(context, '이슬람교'),
        _religionSimpleDialogOption(context, '힌두교'),
        _religionSimpleDialogOption(context, '기타'),
      ],
    );
  }

  _religionSimpleDialogOption(BuildContext context, String s) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          religioninput = s;
        });
      },
      child: Center(child: Text('$s'),) ,
    );
  }
}
