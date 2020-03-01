import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/profiles/profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class YourProfile extends StatelessWidget {
  final User user;

  YourProfile(this.user);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<MyUserData>(builder: (context, value, child) {
            return Column( // UI column 시작
              crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
              children: <Widget>[
                SizedBox(width: double.infinity, height: 20,),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(common_l_gap),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: user.profiles
                        .map((path) => Padding(
                              padding: const EdgeInsets.all(common_gap),
                              child: InkWell(
                                onTap: () {
                                  print(path);
                                },
                                child: ClipRRect( // 상대 프로필 이미지 사진
                                  borderRadius: BorderRadius.circular(14),
                                  child: CachedNetworkImage(
                                    imageUrl: "profiles/$path",
                                    cacheManager: StorageCacheManager(),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.account_circle),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Text(
                    user.nickname,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),

                // 자기소개
                _selfIntroduction(),
                SizedBox(height: 20,),
                // 가치관 질문
                _valueQuestions(),
                _valueQuestions(),
                SizedBox(height: 20,),
                // 기본 정보
                ProfileBasicInfo('나이',
                    (DateTime.now().year - user.birthYear + 1).toString()),
                ProfileBasicInfo('지역', user.region),
                ProfileBasicInfo('직업', user.job),
                ProfileBasicInfo('키', user.height.toString()),
                Padding(
                  padding: const EdgeInsets.all(common_l_gap),
                  child: Center(
                    child: FlatButton(
                      child: const Text(
                        '호감 보내기',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        // 먼저 지금 상대방이 나한테 Receive 를 보냈는지 확인해야 함 => 나중에

                        firestoreProvider.updateUser(value.userData.userKey, {
                          "Sends": FieldValue.arrayUnion([user.userKey]),
                        });
                        firestoreProvider.updateUser(user.userKey, {
                          "Receives":
                              FieldValue.arrayUnion([value.userData.userKey]),
                        });
                        Navigator.pop(context);
                      },
                      color: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      disabledColor: Colors.blue[100],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('호감보내기', style: GoogleFonts.notoSans(fontSize: 15),),
        icon: Icon(FontAwesomeIcons.heart,
          color: Colors.pink,
          size: 15,),
        backgroundColor: Colors.blue[50],
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
                            '제 인생에서 가장 중요한 세 가지는 a, b, c 입니다',
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
                            child: Text(
                              '안녕하세요, 저는 ㅇㅇㅇ입니다. 저는 서울에 살고 있습니다. 반갑습니다',
                              style: TextStyle(fontSize: 15),
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
}