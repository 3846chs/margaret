import 'package:cached_network_image/cached_network_image.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/profiles/profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(user.nickname),
                background: Swiper(
                  itemCount: 2,
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
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.only(top: common_l_gap),
                child: Column(
                  children: <Widget>[
                    _selfIntroduction(), // 저는 이런 가치관을 가진 사람이에요
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                      child: Container(
                        color: Colors.black12,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // 가치관 질문
                    _valueQuestions(),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                      child: Container(
                        color: Colors.black12,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // 기본 정보
                    Padding(
                      padding: const EdgeInsets.all(common_gap),
                      child: Row(
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
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3.0,
                                        offset: Offset(2, 2))
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '기본 정보',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    ProfileBasicInfo('나이',
                        (DateTime.now().year - user.birthYear + 1).toString()),
                    ProfileBasicInfo('지역', user.region),
                    ProfileBasicInfo('직업', user.job),
                    ProfileBasicInfo('키', user.height.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),

//        SingleChildScrollView(
//          child: Consumer<MyUserData>(builder: (context, value, child) {
//            return Column( // UI column 시작
//              crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
//              children: <Widget>[
//                SizedBox(width: double.infinity, height: 20,),
//                SingleChildScrollView(
//                  padding: const EdgeInsets.all(common_l_gap),
//                  scrollDirection: Axis.horizontal,
//                  child: Row(
//                    children: user.profiles
//                        .map((path) => Padding(
//                              padding: const EdgeInsets.all(common_gap),
//                              child: InkWell(
//                                onTap: () {
//                                  print(path);
//                                },
//                                child: ClipRRect( // 상대 프로필 이미지 사진
//                                  borderRadius: BorderRadius.circular(14),
//                                  child: CachedNetworkImage(
//                                    imageUrl: "profiles/$path",
//                                    cacheManager: StorageCacheManager(),
//                                    width: 150,
//                                    height: 150,
//                                    fit: BoxFit.cover,
//                                    placeholder: (context, url) =>
//                                        const CircularProgressIndicator(),
//                                    errorWidget: (context, url, error) =>
//                                        const Icon(Icons.account_circle),
//                                  ),
//                                ),
//                              ),
//                            ))
//                        .toList(),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(common_gap),
//                  child: Text(
//                    user.nickname,
//                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                  ),
//                ),
//
//                // 자기소개
//                _selfIntroduction(),
//                SizedBox(height: 20,),
//                // 가치관 질문
////                _valueQuestions(),
////                _valueQuestions(),
//                SizedBox(height: 20,),
//                // 기본 정보
//                ProfileBasicInfo('나이',
//                    (DateTime.now().year - user.birthYear + 1).toString()),
//                ProfileBasicInfo('지역', user.region),
//                ProfileBasicInfo('직업', user.job),
//                ProfileBasicInfo('키', user.height.toString()),
//                Padding(
//                  padding: const EdgeInsets.all(common_l_gap),
//                  child: Center(
//                    child: FlatButton(
//                      child: const Text(
//                        '호감 보내기',
//                        style: TextStyle(
//                          color: Colors.black,
//                        ),
//                      ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 채팅으로 이동
          // 채팅방 시작할 때 UI -> 사진 참고
        },
        label: Text(
          '채팅하기',
          style: TextStyle(fontFamily: FontFamily.nanumBarunpen, fontSize: 15),
        ),
        icon: Icon(
          FontAwesomeIcons.heart,
          color: Colors.pink,
          size: 15,
        ),
        backgroundColor: Colors.blue[50],
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

  Padding _valueQuestions() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Column(
        children: <Widget>[
          Row(
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
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3.0,
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Q. 서운한 것을 그때그때 말하는 편인가요?',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  'A.',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(222, 222, 255, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  '저는 서운한 것을 그때그때 말하는 편이에요..',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
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
              Padding(
                padding: const EdgeInsets.all(common_gap),
                child: Center(
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Color.fromRGBO(255, 178, 245, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      shadows: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3.0,
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '❤ 나를 표현하는 가치관은?',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '안녕하세요. 저는 test1입니다. 저는 열정이 있는 사람입니다. 일과 사랑 모두 열정적으로 하고 싶어요~',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
