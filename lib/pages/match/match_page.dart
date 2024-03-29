import 'package:margaret/constants/balance.dart';
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

class MatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(
      builder: (context, myUserData, child) {
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
          UserKeys.KEY_NUMMYQUESTIONS : MAX_NUM_MY_QUESTIONS, // Random Q&A 의 <내 질문 보내기> 횟수
        });

        return LoadingPage();
      },
    );
  }
}
