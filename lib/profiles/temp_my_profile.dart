import 'package:cached_network_image/cached_network_image.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/firebase/storage_provider.dart';
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
                          .map((path) => FutureBuilder<String>(
                              future:
                                  storageProvider.getImageUri("profiles/$path"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Padding(
                                    padding: const EdgeInsets.all(common_gap),
                                    child: InkWell(
                                      onTap: () {
                                        print(path);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: CachedNetworkImage(
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          imageUrl: snapshot.data,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.account_circle),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const CircularProgressIndicator();
                              }))
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
                        SizedBox(width: 40,),
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
                        SizedBox(width: 40,),
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
                            '출생 연도',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$birthYear',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 40,),
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
                        SizedBox(width: 40,),
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
                            child: Text(
                              '$region',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 40,),
                      ],
                ));
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
                          '키',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: Center(
                          child: InkWell(
                            child: Text(
                              '$height',
                               style: TextStyle(fontSize: 15),
                            ),
                            onTap: () {
                              return showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: Container(
                                    height: 600,
                                      child: _buildHeightDialog(context)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 40,)
                    ],
                  ),
                );
  }

  // simpleDialogOptionList
  create_simpleDialogOptionList (int a, int b ){
    var list = new List<int>.generate(b-a+1, (index) => a + index);
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
      children: create_simpleDialogOptionList(140, 190)
    );
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
                  child: Text(
                    job,
                    style: TextStyle(fontSize: 15),
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
}
