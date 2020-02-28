import 'package:cached_network_image/cached_network_image.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final String src;

  ImagePage(this.src);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: src,
          cacheManager: StorageCacheManager(),
        ),
      ),
    );
  }
}
