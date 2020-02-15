import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/profiles/profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourProfile extends StatelessWidget {
  final DocumentSnapshot yourDocumentSnapshot;

  YourProfile(this.yourDocumentSnapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<MyUserData>(builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(common_l_gap),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        "https://www.topstarnews.net/news/photo/201803/380832_25485_2752.jpg"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Text(
                    yourDocumentSnapshot.data['nickname'],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                ProfileBasicInfo(
                    '나이',
                    (DateTime.now().year -
                            yourDocumentSnapshot.data['birthYear'] +
                            1)
                        .toString()),
                ProfileBasicInfo('지역', yourDocumentSnapshot.data['region']),
                ProfileBasicInfo('직업', yourDocumentSnapshot.data['region']),
                ProfileBasicInfo(
                    '키', yourDocumentSnapshot.data['height'].toString()),
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

                        Firestore.instance
                            .collection(COLLECTION_USERS)
                            .document(value.userData.userKey)
                            .updateData({
                          "Sends": FieldValue.arrayUnion(
                              [yourDocumentSnapshot.documentID])
                        });
                        Firestore.instance
                            .collection(COLLECTION_USERS)
                            .document(yourDocumentSnapshot.documentID)
                            .updateData({
                          "Receives":
                              FieldValue.arrayUnion([value.userData.userKey])
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
    );
  }
}
