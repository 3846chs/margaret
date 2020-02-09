import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/widgets/loading.dart';
import 'package:datingapp/widgets/match_widgets/today_people_card.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:provider/provider.dart';

class TodayPeople extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Users')
          //.where('gender', isEqualTo: '여성')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return LoadingPage();
        else if (!snapshot.hasData)
          return LoadingPage();
        else {
          User myUser = Provider.of<MyUserData>(context, listen: false).data;
          return _buildTodayPeople(snapshot.data.documents, myUser);
        }
      },
    ));
  }

  Widget _buildTodayPeople(List<DocumentSnapshot> documents, User myUser) {
    final recommendedPeople = documents
        .where((doc) => (doc['gender'] != myUser.gender &&
            doc['recentMatchState'] == myUser.recentMatchState &&
            doc['recentMatchTime'].toDate().year == DateTime.now().year &&
            doc['recentMatchTime'].toDate().month == DateTime.now().month &&
            doc['recentMatchTime'].toDate().day == DateTime.now().day))
        .take(3) // 이후에 최신순 3명으로 변경해야 함
        .toList();
    if (recommendedPeople.length < 3)
      return NotShowPeople();
    else
      return ShowPeople(recommendedPeople: recommendedPeople);
  }
}

class NotShowPeople extends StatelessWidget {
  const NotShowPeople({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('아직 해당 선택지를 고른 사람이 없습니다. 기다려주세요.');
  }
}

class ShowPeople extends StatelessWidget {
  const ShowPeople({
    Key key,
    @required this.recommendedPeople,
  }) : super(key: key);

  final List<DocumentSnapshot> recommendedPeople;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Text(
          '연애할 때 상대방을 위해 얼마나 포기할 수 있나요? 전부를 희생할 수 있나요?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '전부 희생할 수 있다',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TodayPeopleCard(recommendedPeople[0]),
        TodayPeopleCard(recommendedPeople[1]),
        TodayPeopleCard(recommendedPeople[2]),
      ],
    );
  }
}
