import 'dart:math';

import 'package:margaret/constants/size.dart';
import 'package:margaret/data/user.dart';
import 'package:flutter/material.dart';
import 'package:margaret/firebase/storage_provider.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double width;
  final double height;

  UserAvatar({this.user, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    if (user != null && user.profiles.length > 0) {
      return CircleAvatar(
        radius: thumbnail_avatar_radius,
        child: ClipOval(
          child: FutureBuilder<String>(
            future:
                storageProvider.getFileURL("profiles/${user.profiles.first}"),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: const Icon(Icons.account_circle),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              return Image.network(
                snapshot.data,
                width: width,
                height: height,
              );
            },
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: thumbnail_avatar_radius,
      child: ClipOval(
        child: Icon(
          Icons.account_circle,
          size: min(width, height),
        ),
      ),
    );
  }
}
