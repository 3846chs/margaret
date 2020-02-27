import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/firebase/storage_cache_manager.dart';
import 'package:datingapp/profiles/profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectedPerson extends StatelessWidget {
  final User user;

  SelectedPerson(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<MyUserData>(builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Text(
                    user.nickname,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
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
                        '선택하고 매칭 종료',
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

                        var now = DateTime.now();
                        var formatter = DateFormat('yyyy-MM-dd');
                        String formattedDate = formatter.format(now);

                        // 12시 근처에 선택 시 다음날 날짜의 selected Person 이 업데이트 될 수 있음 => 나중에 처리

                        Firestore.instance
                            .collection(COLLECTION_USERS)
                            .document(value.userData.userKey)
                            .collection(TODAYQUESTIONS)
                            .document(formattedDate)
                            .updateData({'finished': true});
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
    );
  }
}
