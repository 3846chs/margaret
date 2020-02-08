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
        if (snapshot.data == null) // 없으면 에러
          return LoadingPage();
        else if (!snapshot.hasData) return _buildNotPeopleAnswer();

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
    //final recommendedPeople = documents.take(3).toList();
    final recommendedPeople = documents
        .where(
            (doc) => (doc['gender'] == '여성' && doc['recentMatchState'][1] != 0))
        .toList();

    return ListView(
      children: recommendedPeople.map((doc) => TodayPeopleCard(doc)).toList(),
    );
  }

  Widget _buildNotPeopleAnswer() {
    return Text('아직 모이지 않았습니다.');
  }
}
