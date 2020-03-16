import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:margaret/constants/balance.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/profile_input_info.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:provider/provider.dart';

class TempMyProfile extends StatefulWidget {
  final User user;

  TempMyProfile({@required this.user});

  @override
  _TempMyProfileState createState() => _TempMyProfileState();
}

class _TempMyProfileState extends State<TempMyProfile> {
  final TextEditingController _introductionController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  String nickname;
  String gender;
  int birthYear;
  String email;
  String region;
  String job;
  int height;
  String smoke;
  String drink;
  String religion;
  String introduction;
  List profiles;

  Future<void> _getProfile(int index) async {
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
        profiles[index] = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nickname = widget.user.nickname;
    gender = widget.user.gender;
    birthYear = widget.user.birthYear;
    email = widget.user.email;
    region = widget.user.region;
    job = widget.user.job;
    height = widget.user.height;
    smoke = widget.user.smoke;
    drink = widget.user.drink;
    religion = widget.user.religion;
    introduction = widget.user.introduction;
    profiles = List.from(widget.user.profiles);

    _introductionController.text = widget.user.introduction;
    _nicknameController.text = widget.user.nickname;
    _jobController.text = widget.user.job;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        allowFontScaling: true);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              '내 프로필',
              style: TextStyle(fontFamily: FontFamily.jua),
            ),
            Spacer(),
            Builder(
              builder: (context) {
                return InkWell(
                  onTap: () async {
                    if (nickname.length > MAX_NICKNAME_LENGTH) {
                      simpleSnackbar(context,
                          '닉네임 글자 수는 $MAX_NICKNAME_LENGTH자 이내로 정해주세요.');
                      return;
                    }
                    if (job.length > MAX_JOB_LENGTH) {
                      simpleSnackbar(
                          context, '직업 글자 수는 $MAX_JOB_LENGTH자 이내로 정해주세요.');
                      return;
                    }
                    _introductionController.clear();
                    _nicknameController.clear();
                    _jobController.clear();

                    firestoreProvider.updateUser(widget.user.userKey, {
                      UserKeys.KEY_NICKNAME: nickname,
                      UserKeys.KEY_JOB: job,
                      UserKeys.KEY_HEIGHT: height,
                      UserKeys.KEY_REGION: region,
                      UserKeys.KEY_SMOKE: smoke,
                      UserKeys.KEY_DRINK: drink,
                      UserKeys.KEY_RELIGION: religion,
                      UserKeys.KEY_INTRODUCTION: introduction,
                      UserKeys.KEY_PROFILES:
                          await Future.wait(profiles.map((profile) async {
                        if (profile is String) return profile;
                        final url = await storageProvider.uploadImg(profile,
                            'profiles/${DateTime.now().millisecondsSinceEpoch}_${widget.user.userKey}');
                        return url.substring(9);
                      })),
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    '완료',
                    style: const TextStyle(fontFamily: FontFamily.jua),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child: Consumer<MyUserData>(builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: screenAwareHeight(30, context),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: profiles
                          .map(
                            (path) => Padding(
                              padding: const EdgeInsets.all(common_gap),
                              child: InkWell(
                                onTap: () {
                                  _getProfile(profiles.indexOf(path));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),

                                  child: (path is String)
                                      ? FutureBuilder<String>(
                                          future: storageProvider
                                              .getImageUri("profiles/$path"),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError)
                                              return const Icon(
                                                  Icons.account_circle);
                                            if (!snapshot.hasData)
                                              return const CircularProgressIndicator();
                                            return Image.network(
                                              snapshot.data,
                                              width: screenAwareWidth(
                                                  130, context),
                                              height: screenAwareHeight(
                                                  130, context),
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.file(
                                          path,
                                          width: screenAwareWidth(130, context),
                                          height:
                                              screenAwareHeight(130, context),
                                          fit: BoxFit.cover,
                                        ),

                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Text(
                      "얼굴이 명확히 보이지 않는 사진의 경우, 사전 통보 없이 삭제될 수 있습니다.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                    Container(
                      height: screenAwareHeight(30, context),
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Center(
                          child: Text(
                        '자기소개 등록',
                        style: TextStyle(
                            fontFamily: FontFamily.nanumBarunpen,
                            color: Colors.grey),
                      )),
                    ),
                    _selfIntroduction(),
                    AutoSizeText(
                      "마가렛은 가치관 소개팅 앱으로 자기소개의 비중이 중요합니다. 매칭 과정에서 사진보다 우선해서 보여지는 정보로, 성실하게 적어주세요. 자신을 소개하거나 자신이 중요하게 생각하는 가치관에 대해 적어주시면 됩니다.",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: ScreenUtil().setSp(15),
                      ),
                      maxLines: 4,
                    ),
                    Container(
                      height: screenAwareHeight(30, context),
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
                    SizedBox(
                      height: screenAwareHeight(5, context),
                    ),
                    _buildNickname(),
                    _buildGender(),
                    _buildBirthYear(),
                    _buildRegion(),
                    _buildCareer(),
                    _buildHeight(),
                    _buildSmoke(),
                    _buildDrink(),
                    _buildReligion(),
                    SizedBox(
                      height: screenAwareHeight(common_gap, context),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  ///////////////////////////// 닉네임 /////////////////////////////////////////
  Padding _buildNickname() {
    return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                  Icon(
                    FontAwesomeIcons.user,
                    color: pastel_purple,
                    size: 15,
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Center(
                    child: Text(
                      '닉네임',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: InkWell(
                          child: SizedBox(
                            width: screenAwareWidth(120, context),
                            child: Center(
                              child: Text(
                                '$nickname',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          onTap: () {
                            return showDialog(
                              context: context,
                              builder: (context) =>
                                  _buildNicknameDialog(context),
                            );
                          }),
                    ),
                  ),
                  SizedBox(width: screenAwareWidth(25, context)),
                ],
              ),
            ),
          ],
        ));
  }

  _buildNicknameDialog(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: TextFormField(
          cursorColor: cursor_color,
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
              // validator 확인해야함
              Navigator.pop(context);
              setState(() {
                nickname = _nicknameController.text;
              });
            },
          ),
          MaterialButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context);
                _nicknameController.text = nickname;
              }),
        ],
      ),
    );
  }

  ////////////////////////////// 성별 //////////////////////////////////////////
  Padding _buildGender() {
    return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                  Icon(
                    FontAwesomeIcons.venusMars,
                    color: pastel_purple,
                    size: 15,
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Center(
                    child: Text(
                      '성별',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        '$gender',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Icon(
                    FontAwesomeIcons.lock,
                    color: pastel_purple,
                    size: 15,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  //////////////////////////// 출생연도 ////////////////////////////////////////
  Padding _buildBirthYear() {
    return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                  Icon(
                    FontAwesomeIcons.birthdayCake,
                    color: pastel_purple,
                    size: 15,
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Center(
                    child: Text(
                      '나이',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        (DateTime.now().year - birthYear + 1).toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Icon(
                    FontAwesomeIcons.lock,
                    color: pastel_purple,
                    size: 15,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  ////////////////////////////// 지역 //////////////////////////////////////////
  Padding _buildRegion() {
    return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                  Icon(
                    Icons.location_on,
                    color: pastel_purple,
                    size: 15,
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Center(
                    child: Text(
                      '지역',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: InkWell(
                        child: SizedBox(
                          width: screenAwareWidth(120, context),
                          child: Center(
                            child: Text(
                              '$region',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: Container(
                                  height: screenAwareHeight(600, context),
                                  child: SimpleDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      children: create_regionOptionList(
                                          choose_region))),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenAwareWidth(25, context),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  create_regionOptionList(List<String> L) {
    var regionOptionList = <SimpleDialogOption>[];
    L.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            region = i;
          });
        },
        child: Center(child: Text('$i')),
      );
      regionOptionList.add(new_simpleDialogOption);
    });
    return regionOptionList;
  }

  ////////////////////////////// 직업 //////////////////////////////////////////
  Widget _buildCareer() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Row(
            children: <Widget>[
              SizedBox(
                width: screenAwareWidth(40, context),
              ),
              Icon(
                FontAwesomeIcons.suitcase,
                color: pastel_purple,
                size: 15,
              ),
              SizedBox(
                width: screenAwareWidth(10, context),
              ),
              Center(
                child: Text(
                  '직업',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          )),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: InkWell(
                        child: SizedBox(
                          width: screenAwareWidth(120, context),
                          child: Center(
                            child: Text(
                              job,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (context) => _buildJobDialog(context),
                          );
                        }),
                    // 클릭하면 팝업창 띄워서 수정하는 디자인으로 갈 예정
                  ),
                ),
                SizedBox(width: screenAwareWidth(25, context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildJobDialog(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: TextFormField(
          cursorColor: cursor_color,
          controller: _jobController,
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text('수정'),
            onPressed: () {
              // validator 확인해야함
              Navigator.pop(context);
              setState(() {
                job = _jobController.text;
              });
            },
          ),
          MaterialButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context);
                _jobController.text = job;
              }),
        ],
      ),
    );
  }

  /////////////////////////////// 키 ///////////////////////////////////////////
  Widget _buildHeight() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: screenAwareWidth(40, context),
                ),
                Icon(
                  FontAwesomeIcons.child,
                  color: pastel_purple,
                  size: 15,
                ),
                SizedBox(
                  width: screenAwareWidth(10, context),
                ),
                Center(
                  child: Text(
                    '키   ',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: InkWell(
                      child: SizedBox(
                        width: screenAwareWidth(120, context),
                        child: Center(
                          child: Text(
                            '$height',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      onTap: () {
                        return showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: Container(
                                height: screenAwareHeight(600, context),
                                child: _buildHeightDialog(context)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: screenAwareWidth(25, context),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // simpleDialogOptionList
  create_simpleDialogOptionList(int a, int b) {
    var list = new List<int>.generate(b - a + 1, (index) => a + index);
    var simpleDialogOptionList = <SimpleDialogOption>[];
    list.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            height = i;
          });
        },
        child: Center(child: Text('$i')),
      );
      simpleDialogOptionList.add(new_simpleDialogOption);
    });
    return simpleDialogOptionList;
  }

  SimpleDialog _buildHeightDialog(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        children: create_simpleDialogOptionList(140, 190));
  }

  //////////////////////////// 흡연여부 ////////////////////////////////////////
  Padding _buildSmoke() {
    return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                  Icon(
                    FontAwesomeIcons.smoking,
                    color: pastel_purple,
                    size: 15,
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Center(
                    child: Text(
                      '흡연 여부',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: InkWell(
                        child: SizedBox(
                          width: screenAwareWidth(120, context),
                          child: Center(
                            child: Text(
                              '$smoke',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: Container(
                                  height: screenAwareHeight(600, context),
                                  child: SimpleDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      children: create_smokeOptionList(
                                          choose_smoke))),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenAwareWidth(25, context),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  create_smokeOptionList(List<String> L) {
    var smokeOptionList = <SimpleDialogOption>[];
    L.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            smoke = i;
          });
        },
        child: Center(child: Text('$i')),
      );
      smokeOptionList.add(new_simpleDialogOption);
    });
    return smokeOptionList;
  }

  ////////////////////////////// 음주 //////////////////////////////////////////
  Padding _buildDrink() {
    return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                  Icon(
                    FontAwesomeIcons.beer,
                    color: pastel_purple,
                    size: 15,
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Center(
                    child: Text(
                      '음주',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: InkWell(
                        child: SizedBox(
                          width: screenAwareWidth(120, context),
                          child: Center(
                            child: Text(
                              '$drink',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: Container(
                                  height: screenAwareHeight(600, context),
                                  child: SimpleDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      children: create_drinkOptionList(
                                          choose_drink))),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenAwareWidth(25, context),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  create_drinkOptionList(List<String> L) {
    var drinkOptionList = <SimpleDialogOption>[];
    L.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            drink = i;
          });
        },
        child: Center(child: Text('$i')),
      );
      drinkOptionList.add(new_simpleDialogOption);
    });
    return drinkOptionList;
  }

  ////////////////////////////// 종교 //////////////////////////////////////////
  Padding _buildReligion() {
    return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                  Icon(
                    FontAwesomeIcons.pray,
                    color: pastel_purple,
                    size: 15,
                  ),
                  SizedBox(
                    width: screenAwareWidth(10, context),
                  ),
                  Center(
                    child: Text(
                      '종교',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: InkWell(
                        child: SizedBox(
                          width: screenAwareWidth(120, context),
                          child: Center(
                            child: Text(
                              '$religion',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: Container(
                                  height: screenAwareHeight(600, context),
                                  child: SimpleDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    children: create_religionOptionList(
                                        choose_religion),
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenAwareWidth(25, context),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  create_religionOptionList(List<String> L) {
    var religionOptionList = <SimpleDialogOption>[];
    L.forEach((i) {
      var new_simpleDialogOption = new SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            religion = i;
          });
        },
        child: Center(child: Text('$i')),
      );
      religionOptionList.add(new_simpleDialogOption);
    });
    return religionOptionList;
  }

  /////////////////////////// 자기소개 /////////////////////////////////////////

  Padding _selfIntroduction() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: screenAwareWidth(20, context),
              ),
              Icon(
                FontAwesomeIcons.quoteLeft,
                color: pastel_purple,
                size: 15,
              ),
              Spacer(),
            ],
          ),
          InkWell(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        introduction == null
                            ? '등록된 자기소개가 없습니다'
                            : '$introduction',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenAwareWidth(40, context),
                  ),
                ],
              ),
              onTap: () {
                return showDialog(
                  context: context,
                  builder: (context) => _buildIntroductionDialog(context),
                );
              }),
          Row(
            children: <Widget>[
              Spacer(),
              Icon(
                FontAwesomeIcons.quoteRight,
                color: pastel_purple,
                size: 15,
              ),
              SizedBox(
                width: screenAwareWidth(20, context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildIntroductionDialog(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: TextFormField(
          cursorColor: cursor_color,
          maxLength: 80,
          maxLines: 6,
          decoration: _buildInputDecoration('자기소개'),
          controller: _introductionController,
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text('수정'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                introduction = _introductionController.text;
              });
            },
          ),
          MaterialButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context);
                _introductionController.text = introduction;
              }),
        ],
      ),
    );
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
