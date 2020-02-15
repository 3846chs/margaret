import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/widgets/loading.dart';
import 'package:datingapp/pages/match/selected_person_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodayPeopleCard extends StatefulWidget {
  final DocumentSnapshot document;

  TodayPeopleCard(this.document);

  @override
  _TodayPeopleCardState createState() => _TodayPeopleCardState();
}

class _TodayPeopleCardState extends State<TodayPeopleCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: myStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return CircularProgressIndicator();
        else if (!snapshot.hasData) // 해당 날짜에 응답한 유저를 가져왔기 때문에 호출되지 않는게 정상
          return ListTile(
            leading: CircleAvatar(),
            title: Text('등록된 답변이 없습니다.'),
          );
        else {
          print(snapshot.data.data['answer']);
          return Center(
            child: GestureDetector(
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
                                print(widget.document.data['nickname']);
                                // recentMatchState 변경
                                Firestore.instance
                                    .collection(COLLECTION_USERS)
                                    .document(value.userData.userKey)
                                    .updateData({'recentMatchState': -1}); // 완료
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectedPersonProfile(
                                                widget.document)));
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
        }
      },
    );
  }

  Stream<DocumentSnapshot> myStream() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return Firestore.instance
        .collection('Users')
        .document(widget.document.documentID)
        .collection('TodayQuestions')
        .document(formattedDate)
        .snapshots();
  }
}
