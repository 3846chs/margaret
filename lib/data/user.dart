import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';

class User {
  final String userKey;

  final String email;
  final String nickname;
  final String gender;
  final int birthYear;
  final String region;
  final String job;
  final int height;
  final int recentMatchState;
  final Timestamp recentMatchTime;
  final DocumentReference reference;

  User(
      {this.userKey,
      this.email,
      this.nickname,
      this.gender,
      this.birthYear,
      this.region,
      this.job,
      this.height,
      this.recentMatchState,
      this.recentMatchTime,
      this.reference});

  User.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : email = map[KEY_EMAIL],
        nickname = map[KEY_NICKNAME],
        gender = map[KEY_GENDER],
        birthYear = map[KEY_BIRTHYEAR],
        region = map[KEY_REGION],
        job = map[KEY_JOB],
        height = map[KEY_HEIGHT],
        recentMatchState = map[KEY_RECENTMATCHSTATE],
        recentMatchTime = map[KEY_RECENTMATCHTIME];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data,
          snapshot.documentID,
          reference: snapshot.reference,
        );

  Map<String, dynamic> toMap() => {
        KEY_EMAIL: email,
        KEY_NICKNAME: nickname,
        KEY_GENDER: gender,
        KEY_BIRTHYEAR: birthYear,
        KEY_REGION: region,
        KEY_JOB: job,
        KEY_HEIGHT: height,
        KEY_RECENTMATCHSTATE: recentMatchState,
        KEY_RECENTMATCHTIME: recentMatchTime,
      };
}
