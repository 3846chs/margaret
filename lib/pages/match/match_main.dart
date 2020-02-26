import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/widgets/loading_page.dart';
import 'package:datingapp/pages/match/today_finished.dart';
import 'package:datingapp/pages/match/today_people.dart';
import 'package:datingapp/pages/match/today_question.dart';
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
            case MatchState.FINISHED_ONE:
              return TodayFinished();
            case MatchState.FINISHED_TWO:
              return TodayFinished();
            default: // 1 or 2
              return TodayPeople();
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
