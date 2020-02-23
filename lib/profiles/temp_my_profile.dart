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

  String job;

  @override
  void initState() {
    super.initState();
    job = widget.user.job;
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
                  _buildCareer(),
                ],
              );
            }),
          ),
        ),
      ),
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
