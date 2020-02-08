import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayPeopleCard extends StatefulWidget {
  final DocumentSnapshot document;
  String ans = "";

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
          return LoadingPage();
        else if (!snapshot.hasData) // 해당 날짜에 응답한 유저를 가져왔기 때문에 호출되지 않는게 정상
          return ListTile(
            leading: CircleAvatar(),
            title: Text('답변이 없습니다.'),
          );
        else {
          print(snapshot.data.data['answer']);
          return ListTile(
            leading: CircleAvatar(),
            title: Text(snapshot.data.data['answer']),
          );
        }
      },
    );
  }

  Stream<DocumentSnapshot> myStream() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    return Firestore.instance
        .collection('Users')
        .document(widget.document.documentID)
        .collection('TodayQuestions')
        .document(formattedDate) // 테스트용이고 추후에는 formattedDate 로 바꿔줘야 함.
        .snapshots();
  }
}
