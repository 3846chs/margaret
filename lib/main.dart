import 'package:margaret/constants/colors.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/home.dart';
import 'package:margaret/pages/auth/auth_page.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider<MyUserData>(
    create: (context) => MyUserData(), child: OurApp()));

class OurApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PermissionHandler().requestPermissions([PermissionGroup.storage]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Material(
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        return MaterialApp(
          debugShowCheckedModeBanner: false, // 우측상단에 debug 라는 빨간색 띠 없애기
          title: "마가렛",
          home: Consumer<MyUserData>(
            builder: (context, myUserData, child) {
              switch (myUserData.status) {
                case MyUserDataStatus.progress:
                  return LoadingPage();
                case MyUserDataStatus.exist:
                  return Home();
                default:
                  return AuthPage();
              }
            },
          ),
          theme: ThemeData(primarySwatch: white),
        );
      },
    );
  }
}
