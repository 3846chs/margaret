import 'package:margaret/firebase/storage_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show BaseCacheManager, FileFetcherResponse, HttpFileFetcherResponse;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class StorageCacheManager extends BaseCacheManager {
  static const key = "libCachedImageData";

  static StorageCacheManager _instance;

  factory StorageCacheManager() =>
      _instance ?? (_instance = StorageCacheManager._());

  StorageCacheManager._() : super(key, fileFetcher: _storageHttpGetter);

  @override
  Future<String> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _storageHttpGetter(String path,
      {Map<String, String> headers}) async {
    final url = await storageProvider.getImageUri(path);
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}
