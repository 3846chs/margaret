import 'package:cached_network_image/cached_network_image.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/profiles/profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              '내 프로필',
              style:
                  TextStyle(fontFamily: FontFamily.nanumBarunpen, fontSize: 17),
            ),
            Spacer(),
            Text(
              '완료',
              style:
                  TextStyle(fontFamily: FontFamily.nanumBarunpen, fontSize: 17),
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
                      style: TextStyle(
                          fontFamily: FontFamily.nanumBarunpen,
                          color: Colors.grey),
                    )),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(common_l_gap),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: value.userData.profiles
                          .map((path) => Padding(
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
                              ))
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
                      style: TextStyle(
                          fontFamily: FontFamily.nanumBarunpen,
                          color: Colors.grey),
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
