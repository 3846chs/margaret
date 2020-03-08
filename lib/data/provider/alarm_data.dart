import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:margaret/utils/notification.dart';
import 'package:margaret/utils/prefs_provider.dart';

enum AlarmDataStatus { progress, none, exist }

class AlarmData extends ChangeNotifier {
  bool _match = true;
  bool _receive = true;
  bool _newChat = true;
  bool _newTodayQuestion = true;
  bool _newPeerQuestion = true;
  bool _newMyQuestion = true;

  bool get match => _match;
  // 이성 3명과 매칭되었을 때 알람. 각 유저의 TodayQuestions(subcollection) 의 오늘날짜 document 의 recommendedPeople 필드가 생성될 때 trigger
  bool get receive => _receive;
  // 자신에게 호감 보낸 이성 카드가 도착했을 때 알람. receives 에 유저키가 추가될 때 trigger
  bool get newChat => _newChat;
  // 새로운 채팅이 생겼을 때 알람. chats 에 유저키가 추가될 때 trigger
  bool get newTodayQuestion => _newTodayQuestion;
  // 자정에 trigger
  bool get newPeerQuestion => _newPeerQuestion;
  // 유저의 PeerQuestions 이라는 subcollection 이 등록되었을 때 trigger
  bool get newMyQuestion => _newMyQuestion;
  // 유저의 MyQuestions 이라는 subcollection 이 등록되었을 때 trigger

  set match(bool value) {
    _match = value;
    notifyListeners();
  }

  set receive(bool value) {
    _receive = value;
    notifyListeners();
  }

  set newChat(bool value) {
    _newChat = value;
    notifyListeners();
  }

  set newTodayQuestion(bool value) {
    _newTodayQuestion = value;
    notifyListeners();
  }

  set newPeerQuestion(bool value) {
    _newPeerQuestion = value;
    notifyListeners();
  }

  set newMyQuestion(bool value) {
    _newMyQuestion = value;
    notifyListeners();
  }

  DocumentReference _userRef;

  AlarmDataStatus _status = AlarmDataStatus.progress;
  AlarmDataStatus get status => _status;

  Future<void> getData([DocumentReference userRef]) async {
    if (userRef != null) _userRef = userRef;

    final snapshot = await _userRef.get();
    Map alarms = snapshot.data["alarms"];

    if (alarms == null) {
      await _userRef.updateData({
        "alarms": {
          "match": true,
          "newChat": true,
          "newMyQuestion": true,
          "newPeerQuestion": true,
          "newTodayQuestion": true,
          "receive": true,
        }
      });
      return;
    }

    if (alarms.containsKey("match")) _match = alarms["match"];
    if (alarms.containsKey("receive")) _receive = alarms["receive"];
    if (alarms.containsKey("newChat")) _newChat = alarms["newChat"];
    _newTodayQuestion = prefsProvider.getTodayQuestionAlarm();
    if (alarms.containsKey("newPeerQuestion"))
      _newPeerQuestion = alarms["newPeerQuestion"];
    if (alarms.containsKey("newMyQuestion"))
      _newMyQuestion = alarms["newMyQuestion"];

    _status = AlarmDataStatus.exist;

    notifyListeners();
  }

  Future<void> setData([DocumentReference userRef]) async {
    if (userRef != null) _userRef = userRef;

    await flutterLocalNotificationsPlugin.cancel(1);

    if (newTodayQuestion) {
      await flutterLocalNotificationsPlugin.showDailyAtTime(1, "밤 12시가 되었습니다!",
          "오늘의 질문을 확인하려면 클릭하세요.", Time(), platformChannelSpecifics);
    }

    await prefsProvider.setTodayQuestionAlarm(newTodayQuestion);
    await _userRef.updateData({
      "alarms": {
        "match": _match,
        "receive": _receive,
        "newChat": _newChat,
        "newPeerQuestion": _newPeerQuestion,
        "newMyQuestion": _newMyQuestion,
      },
    });
  }
}
