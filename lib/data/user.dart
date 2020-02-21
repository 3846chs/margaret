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
    email = map[KEY_EMAIL];
    profiles = <String>[];
    map[KEY_PROFILES].forEach((v) {
      profiles.add(v.toString());
    });
    nickname = map[KEY_NICKNAME];
    gender = map[KEY_GENDER];
    birthYear = map[KEY_BIRTHYEAR];
    region = map[KEY_REGION];
    job = map[KEY_JOB];
    height = map[KEY_HEIGHT];
    chats = <String>[];
    if (chats.length > 0) {
      map[KEY_CHATS].forEach((v) {
        chats.add(v.toString());
      });
    }
    pushToken = map[KEY_PUSHTOKEN ?? ''];
    recentMatchState = map[KEY_RECENTMATCHSTATE];
    recentMatchTime = map[KEY_RECENTMATCHTIME];
  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data,
          snapshot.documentID,
          reference: snapshot.reference,
        );

  Map<String, dynamic> toMap() => {
        KEY_EMAIL: email,
        KEY_PROFILES: profiles,
        KEY_NICKNAME: nickname,
        KEY_GENDER: gender,
        KEY_BIRTHYEAR: birthYear,
        KEY_REGION: region,
        KEY_JOB: job,
        KEY_HEIGHT: height,
        KEY_RECENTMATCHSTATE: recentMatchState,
        KEY_RECENTMATCHTIME: recentMatchTime,
        KEY_CHATS: chats ?? [],
        KEY_PUSHTOKEN: pushToken ?? '',
      };
}
