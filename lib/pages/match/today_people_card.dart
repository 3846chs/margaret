import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodayPeopleCard extends StatefulWidget {
  final String userKey;

  TodayPeopleCard(this.userKey);

  @override
  _TodayPeopleCardState createState() => _TodayPeopleCardState();
}

class _TodayPeopleCardState extends State<TodayPeopleCard> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection(COLLECTION_USERS)
          .document(widget.userKey)
          .collection(TODAYQUESTIONS)
          .document(formattedDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        if (!snapshot.hasData) // 해당 날짜에 응답한 유저를 가져왔기 때문에 호출되지 않는게 정상
          return ListTile(
            leading: CircleAvatar(),
            title: Text('유저가 해당 질문에 답변을 하지 않았습니다.'),
          );
        print(snapshot.data.data['answer']);

        return Center(
          child: InkWell(
            child: Container(
              margin: EdgeInsets.all(10),
              color: Colors.grey[200],
              width: 300,
              height: 75,
              child: Text(snapshot.data.data['answer']),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Consumer<MyUserData>(
                        builder: (context, value, child) {
                      return AlertDialog(
                        content: Text('이 답변을 선택하시겠습니까?'),
                        actions: <Widget>[
                          MaterialButton(
                            elevation: 5,
                            child: Text('선택'),
                            onPressed: () {
                              Navigator.pop(context);

                              Firestore.instance
                                  .collection(COLLECTION_USERS)
                                  .document(value.userData.userKey)
                                  .updateData({
                                'recentMatchState':
                                    -value.userData.recentMatchState.value
                                // 음수로 변환
                              });

                              Firestore.instance
                                  .collection(COLLECTION_USERS)
                                  .document(value.userData.userKey)
                                  .collection(TODAYQUESTIONS)
                                  .document(formattedDate)
                                  .updateData(
                                      {'selectedPerson': widget.userKey});
                            },
                          ),
                          MaterialButton(
                            elevation: 5,
                            child: Text('취소'),
                            onPressed: () {
                              Navigator.pop(context);
                              print('취소함');
                            },
                          ),
                        ],
                      );
                    });
                  });
            },
          ),
        );
      },
    );
  }
}
