import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodayPeopleCard extends StatefulWidget {
  final DocumentSnapshot document;

  TodayPeopleCard(this.document);

  @override
  _TodayPeopleCardState createState() => _TodayPeopleCardState();
}

class _TodayPeopleCardState extends State<TodayPeopleCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(),
          title: Text(widget.document['nickname']),
        ),
      ],
    );
  }
}
