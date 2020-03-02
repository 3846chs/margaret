import 'package:cached_network_image/cached_network_image.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TempMyProfile extends StatefulWidget {
  final User user;

  TempMyProfile({@required this.user});

  @override
  _TempMyProfileState createState() => _TempMyProfileState();
}

class _TempMyProfileState extends State<TempMyProfile> {
  final _textEditingController = TextEditingController();

  String nickname;
  String gender;
  int birthYear;
  String email;
  String region;
  String job;
  int height;
  String introduction;
  //String answer1;
  //String answer2;

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
    introduction = widget.user.introduction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              '내 프로필',
              style: GoogleFonts.notoSans(fontSize: 17),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                firestoreProvider.updateUser(widget.user.userKey, {
                  UserKeys.KEY_JOB: job,
                  UserKeys.KEY_HEIGHT: height,
                  UserKeys.KEY_REGION: region,
                  UserKeys.KEY_INTRODUCTION: introduction,
                  //UserKeys.KEY_ANSWER1: answer1,
                  //UserKeys.KEY_ANSWER2: answer2,
                });

                Navigator.pop(context);
              },
              child: Text(
                '완료',
                style: GoogleFonts.notoSans(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(common_l_gap),
            child: Consumer<MyUserData>(builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 30,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                        child: Text(
                      '사진 등록',
                      style: GoogleFonts.notoSans(color: Colors.grey),
                    )),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(common_l_gap),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: value.userData.profiles
                          .map(
                            (path) => Padding(
                              padding: const EdgeInsets.all(common_gap),
                              child: InkWell(
                                onTap: () {
                                  print(path);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: CachedNetworkImage(
                                    imageUrl: "profiles/$path",
                                    cacheManager: StorageCacheManager(),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.account_circle),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                        child: Text(
                      '기본 정보 등록',
                      style: GoogleFonts.notoSans(color: Colors.grey),
                    )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _buildNickname(),
                  _buildGender(),
                  _buildBirthYear(),
                  _buildEmail(),
                  _buildRegion(),
                  _buildCareer(),
                  _buildHeight(),
                  Container(
                    height: 30,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                        child: Text(
                          '가치관 정보 등록',
                          style: GoogleFonts.notoSans(color: Colors.grey),
                        )),
                  ),
                  _selfIntroduction(),
//                  _valueQuestions(),
//                  _valueQuestions(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Padding _buildNickname() {
    return Padding(
                  padding: const EdgeInsets.all(common_gap),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        Icon(
                          FontAwesomeIcons.user,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            '닉네임',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$nickname',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 25,),
                        Icon(
                          FontAwesomeIcons.lock,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                      ],
                ));
  }

  Padding _buildGender() {
    return Padding(
                  padding: const EdgeInsets.all(common_gap),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        Icon(
                          FontAwesomeIcons.venusMars,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            '성별',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$gender',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 25,),
                        Icon(
                          FontAwesomeIcons.lock,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                      ],
                ));
  }
  Padding _buildBirthYear() {
    return Padding(
                  padding: const EdgeInsets.all(common_gap),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        Icon(
                          FontAwesomeIcons.birthdayCake,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            '나이',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Center(
                            child: Text(
                              (DateTime.now().year - birthYear + 1).toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 25,),
                        Icon(
                          FontAwesomeIcons.lock,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                      ],
                ));
  }
  Padding _buildEmail() {
    return Padding(
                  padding: const EdgeInsets.all(common_gap),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        Icon(
                          FontAwesomeIcons.envelope,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            '이메일',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$email',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 25,),
                        Icon(
                          FontAwesomeIcons.lock,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                      ],
                ));
  }
  Padding _buildRegion() {
    return Padding(
                  padding: const EdgeInsets.all(common_gap),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        Icon(
                          FontAwesomeIcons.mapMarked,
                          color: Color.fromRGBO(222, 222, 255, 1),
                          size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            '지역',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Center(
                            child: InkWell(
                              child: SizedBox(
                                width: 80,
                                child: Center(
                                  child: Text(
                                    '$region',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              onTap: (){
                                return showDialog(
                                  context: context,
                                  builder: (context) => Center(
                                    child: Container(
                                        height: 600, child: _buildRegionDialog(context)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 40,),
                      ],
                ));
  }

  SimpleDialog _buildRegionDialog(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        _regionSimpleDialogOption(context, '서울'),
        _regionSimpleDialogOption(context, '부산'),
        _regionSimpleDialogOption(context, '인천'),
        _regionSimpleDialogOption(context, '광주'),
        _regionSimpleDialogOption(context, '대전'),
        _regionSimpleDialogOption(context, '대구'),
        _regionSimpleDialogOption(context, '울산'),
        _regionSimpleDialogOption(context, '경기'),
        _regionSimpleDialogOption(context, '강원'),
        _regionSimpleDialogOption(context, '충북'),
        _regionSimpleDialogOption(context, '충남'),
        _regionSimpleDialogOption(context, '전북'),
        _regionSimpleDialogOption(context, '전남'),
        _regionSimpleDialogOption(context, '경북'),
        _regionSimpleDialogOption(context, '경남'),
        _regionSimpleDialogOption(context, '제주'),
      ],
    );
  }

  SimpleDialogOption _regionSimpleDialogOption(BuildContext context, String regionName) {
    return SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            region = regionName;
          });
        },
        child: Center(child: Text('$regionName')),
      );
  }

  Widget _buildHeight() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 40,
          ),
          Icon(
            FontAwesomeIcons.child,
            color: Color.fromRGBO(222, 222, 255, 1),
            size: 15,
          ),
          SizedBox(
            width: 10,
          ),
          Center(
            child: Text(
              '키   ',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Spacer(),
          Expanded(
            child: Center(
              child: InkWell(
                child: SizedBox(
                  width: 80,
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
                          height: 600, child: _buildHeightDialog(context)),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            width: 40,
          )
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
    return SimpleDialog(children: create_simpleDialogOptionList(140, 190));
  }

  Widget _buildCareer() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 40,
          ),
          Icon(
            FontAwesomeIcons.suitcase,
            color: Color.fromRGBO(222, 222, 255, 1),
            size: 15,
          ),
          SizedBox(
            width: 10,
          ),
          Center(
            child: Text(
              '직업',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Spacer(),
          Expanded(
            child: Center(
              child: InkWell(
                  child: SizedBox(
                    width: 80,
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
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  AlertDialog _buildJobDialog(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        controller: _textEditingController,
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text('수정'),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              job = _textEditingController.text;
              _textEditingController.clear();
            });
          },
        ),
        MaterialButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _textEditingController.clear();
              });
            }),
      ],
    );
  }

  Padding _selfIntroduction() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Icon(
                FontAwesomeIcons.quoteLeft,
                color: Color.fromRGBO(222, 222, 255, 1),
                size: 15,
              ),
              Spacer(),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 40,),
              Expanded(
                child: Center(
                  child: InkWell(
                    child: Text(
                      '$introduction',
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (context) => _buildIntroductionDialog(context),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 40,),
            ],
          ),
          Row(
            children: <Widget>[
              Spacer(),
              Icon(
                FontAwesomeIcons.quoteRight,
                color: Color.fromRGBO(222, 222, 255, 1),
                size: 15,
              ),
              SizedBox(width: 20,),
            ],
          ),
        ],
      ),
    );
  }

  Padding _valueQuestions() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 5) ,
                child: Text('Q.',
                  style: TextStyle(fontSize: 20, color: Color.fromRGBO(222, 222, 255, 1), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  '인생에서 가장 중요한 세 가지는 무엇인가요?',
                  style: TextStyle(fontSize: 15, color: Color.fromRGBO(222, 222, 255, 1)),
                ),
              ),
              SizedBox(width: 10,),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 5) ,
                child: Text('A.',
                  style: TextStyle(fontSize: 20, color: Color.fromRGBO(222, 222, 255, 1), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  '아직 응답하지 않았습니다. 응답하기 클릭',
                  style: TextStyle(fontSize: 15, ),
                ),
              ),
              SizedBox(width: 10,),
            ],
          ),
        ],
      ),
    );
  }

  AlertDialog _buildIntroductionDialog(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        controller: _textEditingController,
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text('수정'),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              introduction = _textEditingController.text;
              _textEditingController.clear();
            });
          },
        ),
        MaterialButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _textEditingController.clear();
              });
            }),
      ],
    );
  }
}
