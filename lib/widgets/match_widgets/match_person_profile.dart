import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/widgets/profile_widgets/profile_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchPersonProfile extends StatelessWidget {
  final DocumentSnapshot yourDocumentSnapshot;

  MatchPersonProfile(this.yourDocumentSnapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<MyUserData>(builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(common_l_gap),
                  child: Image.network(
                    "https://pbs.twimg.com/profile_images/1216073149390807040/d7xwgJnI_400x400.jpg",
                    // 아이유 사진을 임시로 사용함.
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
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
                      onPressed: null,
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
