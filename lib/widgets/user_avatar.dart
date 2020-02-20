import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/storage_provider.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final User user;

  UserAvatar({this.user});

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return FutureBuilder<String>(
        future: storageProvider.getImageUri("profiles/${user.profiles.first}"),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return CircleAvatar(
            radius: thumbnail_avatar_radius,
            backgroundImage: NetworkImage(snapshot.data),
          );
        },
      );
    }

    return CircleAvatar(
      radius: thumbnail_avatar_radius,
      backgroundColor: Colors.primaries[0],
    );
  }
}
