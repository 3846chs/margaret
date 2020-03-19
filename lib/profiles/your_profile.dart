import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/profiles/your_profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class YourProfile extends StatelessWidget {
  final User user;

  YourProfile(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            _buildSliverAppBar(context),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.only(top: common_l_gap),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(common_gap),
                      child: _buildIntroduction(),
                    ), // 저는 이런 가치관을 가진 사람이에요
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.black12,
                      height: 5,
                    ),
                    const SizedBox(height: 5),
                    // 기본 정보
                    Padding(
                      padding: const EdgeInsets.all(common_gap),
                      child: _buildBasicInfo(),
                    ),
                    YourProfileBasicInfo('나이',
                        (DateTime.now().year - user.birthYear + 1).toString()),
                    YourProfileBasicInfo('지역', user.region),
                    YourProfileBasicInfo('직업', user.job),
                    YourProfileBasicInfo('키', user.height.toString()),
                    YourProfileBasicInfo('종교', user.religion),
                    YourProfileBasicInfo('흡연 여부', user.smoke),
                    YourProfileBasicInfo('음주 여부', user.drink),
                  ],
                ),
              ),
            ),
          ],
        ),

//                      onPressed: () {
//                        // 먼저 지금 상대방이 나한테 Receive 를 보냈는지 확인해야 함 => 나중에
//
//                        firestoreProvider.updateUser(value.userData.userKey, {
//                          "Sends": FieldValue.arrayUnion([user.userKey]),
//                        });
//                        firestoreProvider.updateUser(user.userKey, {
//                          "Receives":
//                              FieldValue.arrayUnion([value.userData.userKey]),
//                        });
//                        Navigator.pop(context);
//                      },
//                      color: Colors.blue[50],
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(6),
//                      ),
//                      disabledColor: Colors.blue[100],
//                    ),
//                  ),
//                ),
//              ],
//            );
//          }),
//        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_gap),
          child: Center(
            child: Container(
              decoration: ShapeDecoration(
                color: pastel_purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                shadows: [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(2, 2),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '기본 정보',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          user.nickname,
          style: TextStyle(
            fontSize: 20,
            fontFamily: FontFamily.jua,
          ),
        ),
        background: Swiper(
          loop: false,
          itemCount: user.profiles.length,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              // 상대 프로필 이미지 사진
              child: FutureBuilder<String>(
                future: storageProvider
                    .getFileURL("profiles/" + user.profiles[index].toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData)
                    return const Icon(Icons.account_circle);
                  return Image.network(
                    snapshot.data,
                    //width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildContainer(BuildContext context) {
    return Container(
      child: Row(
        children: user.profiles
            .map((path) => ClipRRect(
                  // 상대 프로필 이미지 사진
                  child: FutureBuilder<String>(
                    future: storageProvider.getFileURL("profiles/$path"),
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !snapshot.hasData)
                        return Icon(Icons.account_circle,
                            size: min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height));
                      return Image.network(
                        snapshot.data,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildIntroduction() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(
              FontAwesomeIcons.quoteLeft,
              color: pastel_purple,
              size: 15,
            ),
            Spacer(),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 40),
            Expanded(
              child: Center(
                child: Text(
                  user.introduction ?? '등록된 자기소개가 없습니다',
                  style: const TextStyle(
                      fontSize: 23, fontFamily: FontFamily.miSaeng),
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
        Row(
          children: <Widget>[
            Spacer(),
            Icon(
              FontAwesomeIcons.quoteRight,
              color: pastel_purple,
              size: 15,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}
