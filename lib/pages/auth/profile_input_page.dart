import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/balance.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/profile_input_info.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final _jobController = TextEditingController();
  final _introductionController = TextEditingController();

  List<File> _profiles = [];

  List<bool> _genderSelected = [true, false];

  bool _isButtonEnabled = true;

  String nicknameInput = '$MAX_NICKNAME_LENGTH자 이내';
  String birthYearInput = '출생 연도를 입력해주세요';
  String regionInput = '사는 지역을 입력해주세요';
  String jobInput = '직업을 입력해주세요';
  String heightInput = '키를 입력해주세요';
  String smokeInput = '흡연 여부를 선택해주세요';
  String drinkInput = '음주 여부를 선택해주세요';
  String religionInput = '종교를 선택해주세요';
  String introductionInput = '자기소개를 입력해주세요';

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
    _jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: screenAwareHeight(50, context),
                    width: double.infinity,
                    color: pastel_purple,
                    child: Center(
                      child: Text(
                        '마가렛 가입을 환영합니다',
                        style: TextStyle(
                            fontFamily: FontFamily.jua,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenAwareHeight(common_gap, context),
                  ),
                  Container(
                    height: screenAwareHeight(30, context),
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                        child: Text(
                      '사진 등록',
                      style: TextStyle(
                          fontFamily: FontFamily.nanumBarunpen,
                          color: Colors.black),
                    )),
                  ),
                  SizedBox(
                    height: screenAwareHeight(common_gap, context),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(common_gap),
                            child: _profiles.length < 1
                                ? SizedBox(
                                    width: screenAwareWidth(150, context),
                                    height: screenAwareHeight(150, context),
                                    child: RaisedButton(
                                      child: const Icon(Icons.add_a_photo),
                                      onPressed: _getProfile,
                                    ),
                                  )
                                : FlatButton(
                                    onPressed: () => _getProfile(0),
                                    child: Image.file(
                                      _profiles[0],
                                      height: screenAwareHeight(150, context),
                                      width: screenAwareWidth(150, context),
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(common_gap),
                            child: _profiles.length < 2
                                ? SizedBox(
                                    width: screenAwareWidth(150, context),
                                    height: screenAwareHeight(150, context),
                                    child: RaisedButton(
                                      child: const Icon(Icons.add_a_photo),
                                      onPressed: _getProfile,
                                    ),
                                  )
                                : FlatButton(
                                    onPressed: () => _getProfile(1),
                                    child: Image.file(
                                      _profiles[1],
                                      height: screenAwareHeight(150, context),
                                      width: screenAwareWidth(150, context),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: Center(
                        child: Text(
                      '서로 다른 본인 사진 2개를 등록해주세요. 얼굴이 명확히 보이지 않는 사진은 통보 없이 삭제될 수 있습니다.',
                      style: TextStyle(
                          color: _profiles.length == 2
                              ? Colors.grey
                              : Colors.redAccent),
                    )),
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Container(
                    height: screenAwareHeight(30, context),
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                        child: Text(
                      '기본 정보 등록',
                      style: TextStyle(
                          fontFamily: FontFamily.nanumBarunpen,
                          color: Colors.black),
                    )),
                  ),
                  SizedBox(
                    height: screenAwareHeight(common_gap, context),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.user,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '닉네임',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Container(
                          height: screenAwareHeight(60, context),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text('$nicknameInput',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height:
                                                screenAwareHeight(600, context),
                                            width:
                                                screenAwareWidth(300, context),
                                            child:
                                                _buildNicknameDialog(context)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                    ],
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.venusMars,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '성별',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Center(
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(10),
                            children: [
                              Text(
                                '남성',
                                style: TextStyle(
                                    color: _genderSelected[0] == true
                                        ? Colors.blue
                                        : Colors.black12),
                              ),
                              Text(
                                '여성',
                                style: TextStyle(
                                    color: _genderSelected[1] == true
                                        ? Colors.pinkAccent
                                        : Colors.black12),
                              ),
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
                      ),
                    ],
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Text(
                    '가입 후 성별은 수정이 불가합니다.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.birthdayCake,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '출생 연도',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Container(
                          height: screenAwareHeight(60, context),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text('$birthYearInput',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height:
                                                screenAwareHeight(600, context),
                                            width:
                                                screenAwareWidth(300, context),
                                            child: SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              children:
                                                  create_birthyearOptionList(
                                                      choose_birthyear[0],
                                                      choose_birthyear[1]),
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                    ],
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Text(
                    '가입 후 출생 연도는 수정이 불가합니다.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        Icons.location_on,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '지역',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Container(
                          height: screenAwareHeight(60, context),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text('$regionInput',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height:
                                                screenAwareHeight(600, context),
                                            width:
                                                screenAwareWidth(300, context),
                                            child: SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              children: create_regionOptionList(
                                                  choose_region),
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                    ],
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.suitcase,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '직업',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Container(
                          height: screenAwareHeight(60, context),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text('$jobInput',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height:
                                                screenAwareHeight(600, context),
                                            width:
                                                screenAwareWidth(300, context),
                                            child: _buildJobDialog(context)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                    ],
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.child,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '키',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Container(
                          height: screenAwareHeight(60, context),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text('$heightInput',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height:
                                                screenAwareHeight(600, context),
                                            width:
                                                screenAwareWidth(300, context),
                                            child: _buildHeightDialog(context)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                    ],
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.smoking,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '흡연 여부',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Container(
                          height: screenAwareHeight(60, context),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text('$smokeInput',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height:
                                                screenAwareHeight(600, context),
                                            width:
                                                screenAwareWidth(300, context),
                                            child: SimpleDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                children:
                                                    create_smokeOptionList(
                                                        choose_smoke))),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                    ],
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.beer,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '음주 여부',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Container(
                          height: screenAwareHeight(60, context),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text('$drinkInput',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height:
                                                screenAwareHeight(600, context),
                                            width:
                                                screenAwareWidth(300, context),
                                            child: SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              children: create_drinkOptionList(
                                                  choose_drink),
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                    ],
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.pray,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '종교',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(20, context),
                      ),
                      Expanded(
                        child: Container(
                          height: screenAwareHeight(60, context),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300], width: 1)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenAwareWidth(10, context),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text('$religionInput',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15)),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: Container(
                                            height:
                                                screenAwareHeight(600, context),
                                            width:
                                                screenAwareWidth(300, context),
                                            child: SimpleDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                children:
                                                    create_religionOptionList(
                                                        choose_religion))),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: screenAwareWidth(10, context)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenAwareWidth(40, context),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenAwareHeight(40, context),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Icon(
                        FontAwesomeIcons.award,
                        color: pastel_purple,
                        size: 15,
                      ),
                      SizedBox(
                        width: screenAwareWidth(10, context),
                      ),
                      Container(
                        width: screenAwareWidth(70, context),
                        child: Center(
                          child: Text(
                            '자기소개',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenAwareHeight(20, context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "자기소개는 매칭 과정에서 사진보다 우선해서 보이는 정보입니다. 자신을 소개하거나 추구하는 연애 또는 자신이 중요하게 생각하는 가치관에 대해 자유롭게 적어주시면 됩니다. 가입 후 언제든지 수정할 수 있으니 지금은 간단히 어떤 연애를 원하는지, 어떤 연애 상대를 찾고 있는지 적어볼까요?",
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  TextField(
                    maxLength: 100,
                    maxLines: 5,
                    controller: _introductionController,
                    decoration: _buildInputDecoration('자기소개를 입력해주세요!'),
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Builder(
                    builder: (context) => FlatButton(
                      onPressed: !_isButtonEnabled
                          ? null
                          : () {
                              if (_profiles.length < 2)
                                simpleSnackbar(context, '사진을 2개 등록해주세요.');
                              else if (nicknameInput.length >
                                  MAX_NICKNAME_LENGTH)
                                simpleSnackbar(context,
                                    '닉네임 글자수는 최대 $MAX_NICKNAME_LENGTH자입니다.');
                              else if (nicknameInput ==
                                  '$MAX_NICKNAME_LENGTH자 이내')
                                simpleSnackbar(context, '닉네임을 입력해주세요');
                              else if (birthYearInput == '출생 연도를 입력해주세요')
                                simpleSnackbar(context, '출생 연도 4자리를 입력해주세요');
                              else if (regionInput == '사는 지역을 입력해주세요')
                                simpleSnackbar(context, '지역을 입력해주세요');
                              else if (jobInput == '직업을 입력해주세요')
                                simpleSnackbar(context, '직업을 입력해주세요');
                              else if (heightInput == '키를 입력해주세요')
                                simpleSnackbar(context, '키를 입력해주세요');
                              else if (smokeInput == '흡연 여부를 선택해주세요')
                                simpleSnackbar(context, '흡연 여부를 선택해주세요');
                              else if (drinkInput == '음주 여부를 선택해주세요')
                                simpleSnackbar(context, '음주 여부를 선택해주세요');
                              else if (religionInput == '종교를 선택해주세요')
                                simpleSnackbar(context, '종교를 선택해주세요');
                              else if (_introductionController.text.length == 0)
                                simpleSnackbar(context,
                                    '자기소개에 아무거나 입력해주세요! 나중에 수정할 수 있답니다!');
                              else if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isButtonEnabled = false;
                                });
                                introductionInput =
                                    _introductionController.text;
                                _register(context);
                              }
                            },
                      child: _isButtonEnabled
                          ? Text(
                              "가입하기",
                              style: TextStyle(color: Colors.white),
                            )
                          : const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.black87),
                            ),
                      color: pastel_purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  SizedBox(height: screenAwareHeight(common_l_gap, context)),
                  Text(
                    '로딩이 오래걸릴 경우, 앱을 재실행하면 문제가 해결됩니다!',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (widget.authResult.user == null) {
      simpleSnackbar(context, 'Please try again later!');
    } else {
      final profiles = await Stream.fromIterable(_profiles)
          .asyncMap((image) => storageProvider.uploadFile(image,
              "profiles/${DateTime.now().millisecondsSinceEpoch}_${widget.authResult.user.uid}"))
          .toList();
      final user = User(
        userKey: widget.authResult.user.uid,
        profiles: profiles.map((image) => image.substring(9)).toList(),
        email: widget.authResult.user.email,
        nickname: nicknameInput,
        gender: _genderSelected[0] ? '남성' : '여성',
        birthYear: int.parse(birthYearInput),
        region: regionInput,
        job: jobInput,
        height: int.parse(heightInput),
        smoke: smokeInput,
        drink: drinkInput,
        religion: religionInput,
        introduction: introductionInput,
        recentMatchTime: Timestamp.now(),
        recentMatchState: MatchState.QUESTION,
        exposed: 0,
        numMyQuestions: MAX_NUM_MY_QUESTIONS,
      );

      await firestoreProvider.attemptCreateUser(user);

      await Provider.of<MyUserData>(context, listen: false).update();
      Firestore.instance
          .collection(COLLECTION_STATISTICS)
          .document('statistics')
          .updateData({
        (user.gender == '남성' ? 'boy' : 'girl'): FieldValue.increment(1)
      });
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

  ///////////////////////////// 닉네임 /////////////////////////////////////////
  _buildNicknameDialog(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        controller: _nicknameController,
        decoration: InputDecoration(hintText: '$MAX_NICKNAME_LENGTH자 이내'),
        validator: (value) {
          if (value.isEmpty) {
            return '닉네임을 입력해주세요!';
          } else if (value.length > MAX_NICKNAME_LENGTH) {
            return '닉네임은 $MAX_NICKNAME_LENGTH자리 이내로 해주세요';
          }
          return null;
        },
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text('수정'),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              nicknameInput = _nicknameController.text;
              _nicknameController.clear();
            });
          },
        ),
        MaterialButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _nicknameController.clear();
              });
            }),
      ],
    );
  }

  ////////////////////////////// 성별 //////////////////////////////////////////

  //////////////////////////// 출생연도 ////////////////////////////////////////
  create_birthyearOptionList(int a, int b) {
    var list = new List<int>.generate(b - a, (index) => a + index);
    var simpleDialogOptionList = <SimpleDialogOption>[];
    list.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            birthYearInput = i.toString();
          });
        },
        child: Center(
            child: Text(
          '$i',
          style: TextStyle(fontSize: 17),
        )),
      );
      simpleDialogOptionList.add(new_simpleDialogOption);
    });
    return simpleDialogOptionList;
  }

  ////////////////////////////// 지역 //////////////////////////////////////////
  create_regionOptionList(List<String> L) {
    var regionOptionList = <SimpleDialogOption>[];
    L.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            regionInput = i;
          });
        },
        child: Center(
            child: Text(
          '$i',
          style: TextStyle(fontSize: 17),
        )),
      );
      regionOptionList.add(new_simpleDialogOption);
    });
    return regionOptionList;
  }

  ////////////////////////////// 직업 //////////////////////////////////////////
  _buildJobDialog(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        controller: _jobController,
        decoration: InputDecoration(hintText: '직업을 입력해주세요'),
        validator: (value) {
          if (value.isEmpty) {
            return '직업을 입력해주세요!';
          }
          return null;
        },
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text('수정'),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              jobInput = _jobController.text;
              _jobController.clear();
            });
          },
        ),
        MaterialButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _jobController.clear();
              });
            }),
      ],
    );
  }

  /////////////////////////////// 키 ///////////////////////////////////////////
  _buildHeightDialog(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        children:
            create_simpleDialogOptionList(choose_height[0], choose_height[1]));
  }

  create_simpleDialogOptionList(int a, int b) {
    var list = new List<int>.generate(b - a + 1, (index) => a + index);
    var simpleDialogOptionList = <SimpleDialogOption>[];
    list.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            heightInput = i.toString();
          });
        },
        child: Center(
            child: Text(
          '$i',
          style: TextStyle(fontSize: 17),
        )),
      );
      simpleDialogOptionList.add(new_simpleDialogOption);
    });
    return simpleDialogOptionList;
  }

  //////////////////////////// 흡연여부 ////////////////////////////////////////
  create_smokeOptionList(List<String> L) {
    var smokeOptionList = <SimpleDialogOption>[];
    L.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            smokeInput = i;
          });
        },
        child: Center(
            child: Text(
          '$i',
          style: TextStyle(fontSize: 17),
        )),
      );
      smokeOptionList.add(new_simpleDialogOption);
    });
    return smokeOptionList;
  }

  ////////////////////////////// 음주 //////////////////////////////////////////
  create_drinkOptionList(List<String> L) {
    var drinkOptionList = <SimpleDialogOption>[];
    L.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            drinkInput = i;
          });
        },
        child: Center(
            child: Text(
          '$i',
          style: TextStyle(fontSize: 17),
        )),
      );
      drinkOptionList.add(new_simpleDialogOption);
    });
    return drinkOptionList;
  }

  ////////////////////////////// 종교 //////////////////////////////////////////
  create_religionOptionList(List<String> L) {
    var religionOptionList = <SimpleDialogOption>[];
    L.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            religionInput = i;
          });
        },
        child: Center(
            child: Text(
          '$i',
          style: TextStyle(fontSize: 17),
        )),
      );
      religionOptionList.add(new_simpleDialogOption);
    });
    return religionOptionList;
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
//////////////////////////////////////////////////////////////////////////////

}
