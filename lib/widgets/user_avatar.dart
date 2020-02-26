import 'package:cached_network_image/cached_network_image.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/storage_cache_manager.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final User user;

  UserAvatar({this.user});

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return CircleAvatar(
        radius: thumbnail_avatar_radius,
        backgroundImage: CachedNetworkImageProvider(
          "profiles/${user.profiles.first}",
          cacheManager: StorageCacheManager(),
        ),
      );
    }

    return CircleAvatar(
      radius: thumbnail_avatar_radius,
      backgroundColor: Colors.primaries[0],
    );
  }
}
