import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  bool matchAlarm = true; // 이성 3명과 매칭되었을 때 알람. 각 유저의 TodayQuestions(subcollection) 의 오늘날짜 document 의 recommendedPeople 필드가 생성될 때 trigger
  bool receiveAlarm = true; // 자신에게 호감 보낸 이성 카드가 도착했을 때 알람. receives 에 유저키가 추가될 때 trigger
  bool newChatAlarm = true; // 새로운 채팅이 생겼을 때 알람. chats 에 유저키가 추가될 때 trigger
  bool newTodayQuestion = true; // 자정에 새로운 질문 업데이트 되었을 때 알람

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 설정'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    '매칭 알림',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Switch(
                    value: matchAlarm,
                    onChanged: (value) {
                      setState(() {
                        matchAlarm = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    '호감 알림',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Switch(
                    value: receiveAlarm,
                    onChanged: (value) {
                      setState(() {
                        receiveAlarm = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    '새로운 채팅 알림',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Switch(
                    value: newChatAlarm,
                    onChanged: (value) {
                      setState(() {
                        newChatAlarm = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    '오늘의 질문 알림',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Switch(
                    value: newTodayQuestion,
                    onChanged: (value) {
                      setState(() {
                        newTodayQuestion = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
