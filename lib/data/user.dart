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
  final List<dynamic> recentMatchState;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : email = map[KEY_EMAIL],
        nickname = map[KEY_NICKNAME],
        gender = map[KEY_GENDER],
        birthYear = map[KEY_BIRTHYEAR],
        region = map[KEY_REGION],
        job = map[KEY_JOB],
        height = map[KEY_HEIGHT],
        recentMatchState = map[KEY_RECENTMATCHSTATE];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data,
          snapshot.documentID,
          reference: snapshot.reference,
        );

  static Map<String, dynamic> getMapForCreateUser(String email) {
    Map<String, dynamic> map = Map();
    map[KEY_EMAIL] = email;

    // 아래의 프로필 정보는 default 로 다음과 같이 임시로 설정하였음. 가입 단계에서 이 함수(getMapForCreateUser) 를 변형하여 사용하면 됨
    map[KEY_NICKNAME] = email.split("@")[0];
    map[KEY_GENDER] = '남성';
    map[KEY_BIRTHYEAR] = 1998;
    map[KEY_REGION] = '대전';
    map[KEY_JOB] = '회사원';
    map[KEY_HEIGHT] = 170;
    map[KEY_RECENTMATCHSTATE] = [DateTime.now(), 0];

    return map;
  }
}
