import 'package:cached_network_image/cached_network_image.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/profiles/profile_basic_info.dart';
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
                    ProfileBasicInfo('나이',
                        (DateTime.now().year - user.birthYear + 1).toString()),
                    ProfileBasicInfo('지역', user.region),
                    ProfileBasicInfo('직업', user.job),
                    ProfileBasicInfo('키', user.height.toString()),
                    ProfileBasicInfo('종교', user.religion),
                    ProfileBasicInfo('흡연 여부', user.smoke),
                    ProfileBasicInfo('음주 여부', user.drink),
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
                color: Color.fromRGBO(222, 222, 255, 1),
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
        const SizedBox(width: 10),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(user.nickname),
        background: Swiper(
          loop: false,
          itemCount: user.profiles.length,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              // 상대 프로필 이미지 사진
              child: CachedNetworkImage(
                imageUrl: "profiles/" + user.profiles[index].toString(),
                cacheManager: StorageCacheManager(),
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.account_circle),
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
                  child: CachedNetworkImage(
                    imageUrl: "profiles/$path",
                    cacheManager: StorageCacheManager(),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.account_circle),
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
            Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Center(
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(255, 178, 245, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    shadows: [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '❤ 나를 표현하는 가치관은?',
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
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            const SizedBox(width: 40),
            Expanded(
              child: Center(
                child: Text(
                  user.introduction ?? '등록된 자기소개가 없습니다',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ],
    );
  }
}
