import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/firebase_keys.dart';

class User {
  String userKey;

  List<String> profiles;
  String email;
  String nickname;
  String gender;
  int birthYear;
  String region;
  String job;
  int height;
  String smoke;
  String drink;
  String religion;
  String introduction;
  MatchState recentMatchState;
  Timestamp recentMatchTime;
  int exposed;
  String answer;
  String pushToken;
  DocumentReference reference;

  User(
      {this.userKey,
      this.profiles,
      this.email,
      this.nickname,
      this.gender,
      this.birthYear,
      this.region,
      this.job,
      this.height,
      this.smoke,
      this.drink,
      this.religion,
      this.introduction,
      this.recentMatchState,
      this.recentMatchTime,
      this.exposed,
      this.answer,
      this.pushToken,
      this.reference});

  User.fromMap(Map<String, dynamic> map, this.userKey, {this.reference}) {
    email = map[UserKeys.KEY_EMAIL];
    profiles = <String>[];
    map[UserKeys.KEY_PROFILES].forEach((v) {
      profiles.add(v.toString());
    });
    nickname = map[UserKeys.KEY_NICKNAME];
    gender = map[UserKeys.KEY_GENDER];
    birthYear = map[UserKeys.KEY_BIRTHYEAR];
    region = map[UserKeys.KEY_REGION];
    job = map[UserKeys.KEY_JOB];
    height = map[UserKeys.KEY_HEIGHT];
    smoke = map[UserKeys.KEY_SMOKE];
    drink = map[UserKeys.KEY_DRINK];
    religion = map[UserKeys.KEY_RELIGION];
    introduction = map[UserKeys.KEY_INTRODUCTION];
    pushToken = map[UserKeys.KEY_PUSHTOKEN];
    recentMatchState = MatchState.fromInt(map[UserKeys.KEY_RECENTMATCHSTATE]);
    recentMatchTime = map[UserKeys.KEY_RECENTMATCHTIME];
    exposed = map[UserKeys.KEY_EXPOSED];
    answer = map[UserKeys.KEY_ANSWER];
  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.documentID,
            reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        UserKeys.KEY_EMAIL: email,
        UserKeys.KEY_PROFILES: profiles,
        UserKeys.KEY_NICKNAME: nickname,
        UserKeys.KEY_GENDER: gender,
        UserKeys.KEY_BIRTHYEAR: birthYear,
        UserKeys.KEY_REGION: region,
        UserKeys.KEY_JOB: job,
        UserKeys.KEY_HEIGHT: height,
        UserKeys.KEY_SMOKE: smoke,
        UserKeys.KEY_DRINK: drink,
        UserKeys.KEY_RELIGION: religion,
        UserKeys.KEY_INTRODUCTION: introduction,
        UserKeys.KEY_RECENTMATCHSTATE: recentMatchState.value,
        UserKeys.KEY_RECENTMATCHTIME: recentMatchTime,
        UserKeys.KEY_EXPOSED: exposed,
        UserKeys.KEY_ANSWER: answer,
        UserKeys.KEY_PUSHTOKEN: pushToken,
      };
}

class MatchState {
  final int value;

  const MatchState._fromInt(this.value);

  static MatchState fromInt(int value) {
    switch (value) {
      case 0:
        return QUESTION;
      case -1:
        return FINISHED_ONE;
      case -2:
        return FINISHED_TWO;
      case 1:
        return ANSWER_ONE;
      case 2:
        return ANSWER_TWO;
      default:
        return null;
    }
  }

  static const QUESTION = MatchState._fromInt(0);
  static const FINISHED_ONE = MatchState._fromInt(-1);
  static const FINISHED_TWO = MatchState._fromInt(-2);
  static const ANSWER_ONE = MatchState._fromInt(1);
  static const ANSWER_TWO = MatchState._fromInt(2);
}
