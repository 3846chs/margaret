import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:margaret/pages/match/today_finished.dart';
import 'package:margaret/pages/match/today_people.dart';
import 'package:margaret/pages/match/today_question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(
      builder: (context, myUserData, child) {
        // Send/Receive/Chat에 속하거나 차단한 이성은 다시 매칭하지 않기 => 나중에

        if (myUserData.status != MyUserDataStatus.exist) return LoadingPage();

        final userData = myUserData.userData;
        final recentMatchTime = userData.recentMatchTime.toDate();
        final now = DateTime.now();

        if (recentMatchTime.year == now.year &&
            recentMatchTime.month == now.month &&
            recentMatchTime.day == now.day) {
          switch (userData.recentMatchState) {
            case MatchState.QUESTION:
              return TodayQuestion();
            case MatchState.ANSWER_ONE:
              return TodayPeople();
            case MatchState.ANSWER_TWO:
              return TodayPeople();
            default:
              return TodayFinished();
          }
        }

        firestoreProvider.updateUser(userData.userKey, {
          UserKeys.KEY_RECENTMATCHSTATE: MatchState.QUESTION.value,
          UserKeys.KEY_RECENTMATCHTIME: now,
        });

        return LoadingPage();
      },
    );
  }
}
