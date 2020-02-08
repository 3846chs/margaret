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
          return _buildPeopleAnswer(snapshot.data.documents, myUser);
        }
      },
    ));
  }

  Widget _buildQuestion(String question) {
    return Text(
      question,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPeopleAnswer(List<DocumentSnapshot> documents, User myUser) {
    final recommendedPeople = documents
        .where((doc) => (doc['gender'] != myUser.gender &&
            doc['recentMatchState'][1] == myUser.recentMatchState[1] &&
            doc['recentMatchState'][0].toDate().year == DateTime.now().year &&
            doc['recentMatchState'][0].toDate().month == DateTime.now().month &&
            doc['recentMatchState'][0].toDate().day == DateTime.now().day))
        .take(3) // 이후에 최신순 3명으로 변경해야 함
        .toList();
    if (recommendedPeople.length < 3)
      return Text('아직 해당 선택지를 고른 사람이 없습니다. 기다려주세요.');
    else
      return ListView(
        children: recommendedPeople.map((doc) => TodayPeopleCard(doc)).toList(),
      );
  }
}
