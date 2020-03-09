import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/profiles/profile_basic_info.dart';
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
                        '호감 보내기',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        // 먼저 상대방이 나한테 이미 호감(Receive)을 보냈는지 확인해야 함. 이미 나에게 호감 보냈다면 바로 채팅 이동

                        // User A 가 User B 에게 호감을 보낼 경우, 보낸 시점(ex. 2020-03-07) 이 User B 에게 기록되며
                        // User B 는 Receive 탭의 [오늘의 답변] 버튼에서 User A 의 해당 날짜 답변(2020-03-07 날의 답변)을 조회하여 볼 수 있음.

                        value.userData.reference.updateData({
                          "sends": FieldValue.arrayUnion([user.userKey]),
                        });
                        user.reference
                            .collection("Receives")
                            .document(value.userData.userKey)
                            .setData({
                          "dateTime": Timestamp.now(),
                        });

                        final now = DateTime.now();
                        final formatter = DateFormat('yyyy-MM-dd');
                        final formattedDate = formatter.format(now);

                        // 12시 근처에 선택 시 오류 가능성 => 나중에 처리

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
