import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';

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
  int recentMatchState;
  Timestamp recentMatchTime;
  List<String> chats;
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
      this.recentMatchState,
      this.recentMatchTime,
      this.chats,
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
    chats = <String>[];
    pushToken = map[UserKeys.KEY_PUSHTOKEN];
    map[UserKeys.KEY_CHATS].forEach((v) {
      chats.add(v.toString());
    });
    recentMatchState = map[UserKeys.KEY_RECENTMATCHSTATE];
    recentMatchTime = map[UserKeys.KEY_RECENTMATCHTIME];
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
        UserKeys.KEY_RECENTMATCHSTATE: recentMatchState,
        UserKeys.KEY_RECENTMATCHTIME: recentMatchTime,
        UserKeys.KEY_CHATS: chats,
        UserKeys.KEY_PUSHTOKEN: pushToken,
      };
}
