import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<int> _getDirectorySize(Directory dir) async {
  int size = 0;
  if (dir.existsSync()) {
    try {
      await for (var entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    } catch (_) {}
  }
  return size;
}

Future<double> getCacheSizeMB() async {
  final tempDir = await getTemporaryDirectory();
  final cacheDir = await getApplicationSupportDirectory(); // iOS/macOS
  final totalSizeBytes =
      await _getDirectorySize(tempDir) + await _getDirectorySize(cacheDir);
  return totalSizeBytes / (1024 * 1024);
}


Future<void> clearCache() async {
  final tempDir = await getTemporaryDirectory();
  if (tempDir.existsSync()) {
    tempDir.deleteSync(recursive: true);
    print("Cache cleared: ${tempDir.path}");
  }
}
