import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/pages/chat/chat_detail_page.dart';
import 'package:margaret/profiles/your_profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:provider/provider.dart';

class SelectedPerson extends StatelessWidget {
  final User user;

  SelectedPerson(this.user);

  @override
  Widget build(BuildContext context) {
    final myUser = Provider.of<MyUserData>(context, listen: false).userData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: screenAwareHeight(20, context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: user.profiles
              .map((path) => Padding(
                    padding: const EdgeInsets.all(common_gap),
                    child: InkWell(
                      onTap: () {
                        print(path);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: FutureBuilder<String>(
                            future:
                                storageProvider.getImageUri("profiles/$path"),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Icon(
                                  Icons.account_circle,
                                  size: screenAwareWidth(150, context),
                                );
                              }
                              if (!snapshot.hasData)
                                return const CircularProgressIndicator();
                              return Image.network(
                                snapshot.data,
                                width: screenAwareWidth(150, context),
                                height: screenAwareHeight(150, context),
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(''),
            ),
            Text(
              user.nickname +
                  "(" +
                  (DateTime.now().year - user.birthYear + 1).toString() +
                  '세, ' +
                  user.region +
                  ')',
              style: const TextStyle(fontSize: 23, fontFamily: FontFamily.jua),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('카드 삭제하고 매칭 종료하기'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  '삭제만 하고 싶어요',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  final now = DateTime.now();
                                  final formatter = DateFormat('yyyy-MM-dd');
                                  final formattedDate = formatter.format(now);

                                  myUser.reference
                                      .collection(TODAYQUESTIONS)
                                      .document(formattedDate)
                                      .updateData({'finished': true});
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  '차단하고 싶어요',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  final now = DateTime.now();
                                  final formatter = DateFormat('yyyy-MM-dd');
                                  final formattedDate = formatter.format(now);

                                  myUser.reference
                                      .collection(TODAYQUESTIONS)
                                      .document(formattedDate)
                                      .updateData({'finished': true});

                                  myUser.reference.updateData({
                                    "blocks":
                                        FieldValue.arrayUnion([user.userKey]),
                                  });
                                  user.reference.updateData({
                                    "blocks":
                                        FieldValue.arrayUnion([myUser.userKey]),
                                  });
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Icon(
                    FontAwesomeIcons.solidTrashAlt,
                    color: pastel_purple,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenAwareHeight(12, context),
        ),
        YourProfileBasicInfo('직업', user.job),
        YourProfileBasicInfo('키', user.height.toString()),
        YourProfileBasicInfo('흡연 여부', user.smoke),
        YourProfileBasicInfo('음주 여부', user.drink),
        YourProfileBasicInfo('종교', user.religion),
        SizedBox(
          height: screenAwareHeight(20, context),
        ),
        InkWell(
          onTap: () async {
            // 먼저 상대방이 나한테 이미 호감(Receive)을 보냈는지 확인해야 함. 이미 나에게 호감 보냈다면 바로 채팅 이동
            final doc = await myUser.reference
                .collection("Receives")
                .document(user.userKey)
                .get();
            if (doc != null && doc.exists) {
              final chatKey = myUser.userKey.hashCode <= user.userKey.hashCode
                  ? '${myUser.userKey}-${user.userKey}'
                  : '${user.userKey}-${myUser.userKey}';
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDetailPage(
                            chatKey: chatKey,
                            myKey: myUser.userKey,
                            peer: user,
                          )));
              return;
            }
            // User A 가 User B 에게 호감을 보낼 경우, 보낸 시점(ex. 2020-03-07) 이 User B 에게 기록되며
            // User B 는 Receive 탭의 [오늘의 답변] 버튼에서 User A 의 해당 날짜 답변(2020-03-07 날의 답변)을 조회하여 볼 수 있음.

            myUser.reference.updateData({
              "sends": FieldValue.arrayUnion([user.userKey]),
            });
            user.reference
                .collection("Receives")
                .document(myUser.userKey)
                .setData({
              "dateTime": Timestamp.now(),
            });

            final now = DateTime.now();
            final formatter = DateFormat('yyyy-MM-dd');
            final formattedDate = formatter.format(now);

            // 12시 근처에 선택 시 오류 가능성 => 나중에 처리

            myUser.reference
                .collection(TODAYQUESTIONS)
                .document(formattedDate)
                .updateData({'finished': true});
          },
          child: Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(128.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xfffd5c76),
                  Color(0xffff8951),
                ],
              ),
              boxShadow: [
                const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(3.0, 3.0), // shadow direction: bottom right
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.white,
                  size: 18,
                ),
                Text(
                  "  호감 보내기",
                  style: const TextStyle(
                    fontFamily: FontFamily.jua,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
