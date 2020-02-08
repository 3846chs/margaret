import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/widgets/loading.dart';
import 'package:datingapp/widgets/match_widgets/today_people_card.dart';
import 'package:flutter/material.dart';

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
          return _buildNotPeopleAnswer();
        else
          return _buildPeopleAnswer(snapshot.data.documents);
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

  Widget _buildPeopleAnswer(List<DocumentSnapshot> documents) {
    final recommendedPeople = documents
        .where((doc) => (doc['gender'] == '여성' &&
            doc['recentMatchState'][1] != 0 &&
            doc['recentMatchState'][0].toDate().year == DateTime.now().year &&
            doc['recentMatchState'][0].toDate().month == DateTime.now().month &&
            doc['recentMatchState'][0].toDate().day == DateTime.now().day))
        .take(3) // 이후에 최신순 3명으로 변경해야 함
        .toList();

    return ListView(
      children: recommendedPeople.map((doc) => TodayPeopleCard(doc)).toList(),
    );
  }

  Widget _buildNotPeopleAnswer() {
    return Text('해당 선택지를 고른 사람들이 충분히 모이지 않았습니다.');
  }
}
