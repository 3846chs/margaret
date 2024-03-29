import 'package:flutter/material.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/data/provider/alarm_data.dart';
import 'package:provider/provider.dart';

class AlarmPage extends StatelessWidget {
  final activeTrackColor = Colors.purple[100];
  final activeColor = Colors.purple[500];

  @override
  Widget build(BuildContext context) {
    final alarmData = Provider.of<AlarmData>(context, listen: false);
    alarmData.getData();
    return Consumer<AlarmData>(
      builder: (context, alarmData, _) {
        if (alarmData.status != AlarmDataStatus.exist) {
          return Material(
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '알림 설정',
              style: const TextStyle(fontFamily: FontFamily.jua),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  alarmData.setData();
                  Navigator.pop(context);
                },
                child: Text(
                  '완료',
                  style: const TextStyle(
                    fontFamily: FontFamily.jua,
                    fontSize: 19,
                  ),
                ),
              ),
            ],
          ),
          body: _buildBody(alarmData),
        );
      },
    );
  }

  Widget _buildBody(AlarmData alarmData) {
    return Column(
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
                  value: alarmData.match,
                  onChanged: (value) => alarmData.match = value,
                  activeTrackColor: activeTrackColor,
                  activeColor: activeColor,
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
                  value: alarmData.receive,
                  onChanged: (value) => alarmData.receive = value,
                  activeTrackColor: activeTrackColor,
                  activeColor: activeColor,
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
                  value: alarmData.newChat,
                  onChanged: (value) => alarmData.newChat = value,
                  activeTrackColor: activeTrackColor,
                  activeColor: activeColor,
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
                  value: alarmData.newTodayQuestion,
                  onChanged: (value) => alarmData.newTodayQuestion = value,
                  activeTrackColor: activeTrackColor,
                  activeColor: activeColor,
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
                  '새로운 랜덤 질문',
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
                  value: alarmData.newPeerQuestion,
                  onChanged: (value) => alarmData.newPeerQuestion = value,
                  activeTrackColor: activeTrackColor,
                  activeColor: activeColor,
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
                  '새로운 내 질문 답변 알림',
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
                  value: alarmData.newMyQuestion,
                  onChanged: (value) => alarmData.newMyQuestion = value,
                  activeTrackColor: activeTrackColor,
                  activeColor: activeColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
