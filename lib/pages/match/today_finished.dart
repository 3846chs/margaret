import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/firebase/transformer.dart';
import 'package:datingapp/pages/match/selected_person.dart';
import 'package:datingapp/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodayFinished extends StatelessWidget with Transformer {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    User myUserData = Provider.of<MyUserData>(context, listen: false).userData;
    return StreamBuilder(
        stream: Firestore.instance
            .collection(COLLECTION_USERS)
            .document(myUserData.userKey)
            .collection(TODAYQUESTIONS)
            .document(formattedDate)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return LoadingPage();
          else if (!snapshot.hasData)
            return LoadingPage();
          else {
            if (snapshot.data['finished'] == null ||
                snapshot.data['finished'] == false) {
              String yourKey = snapshot.data['selectedPerson'];
              return StreamBuilder<User>(
                stream: firestoreProvider.connectUser(yourKey),
                builder: (context, snapshot) {
                  if (snapshot.data == null)
                    return LoadingPage();
                  else if (!snapshot.hasData)
                    return LoadingPage();
                  else {
                    User you = snapshot.data;
                    return SelectedPerson(you);
                  }
                },
              );
            } else
              return MatchFinished();
          }
        });
  }
}

class MatchFinished extends StatelessWidget {
  const MatchFinished({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitChasingDots(
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
