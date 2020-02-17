import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/firebase/storage_provider.dart';
import 'package:datingapp/profiles/profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List<DropdownMenuItem<int>> listDrop = <int>[170, 171, 172].map((int value) {
    return DropdownMenuItem<int>(
      value: value,
      child: Text(value.toString()),
    );
  }).toList();

  int _value = 170; // 디폴트 값

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
            Text(
              '완료',
              style: GoogleFonts.notoSans(fontSize: 17),
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
                                        child: Image.network(
                                          snapshot.data,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
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
                  ProfileBasicInfo('성별', value.userData.gender),
                  Divider(
                    color: Colors.grey,
                  ),
                  ProfileBasicInfo(
                      '나이',
                      (DateTime.now().year - value.userData.birthYear + 1)
                          .toString()),
                  Divider(
                    color: Colors.grey,
                  ),
                  ProfileBasicInfo('지역', value.userData.region),
                  Divider(
                    color: Colors.grey,
                  ),
                  ProfileBasicInfo('직업', value.userData.job),
                  Divider(
                    color: Colors.grey,
                  ),
                  ProfileBasicInfo('키', value.userData.height.toString()),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
