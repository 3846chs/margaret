import 'package:cached_network_image/cached_network_image.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:flutter/material.dart';

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
          child: CachedNetworkImage(
            width: width,
            height: height,
            imageUrl: "profiles/${user.profiles.first}",
            cacheManager: StorageCacheManager(),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.account_circle),
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
