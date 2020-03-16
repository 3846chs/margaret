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
    if (user != null) {
      return CircleAvatar(
        radius: 30.0,
        child: ClipOval(
          child: FutureBuilder<String>(
            future:
                storageProvider.getImageUri("profiles/${user.profiles.first}"),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Icon(
                  Icons.account_circle,
                  size: min(width, height),
                );
              if (!snapshot.hasData) return const CircularProgressIndicator();
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
      backgroundColor: Colors.primaries[0],
    );
  }
}
