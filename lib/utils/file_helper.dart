import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Helper class to handle file operations across platforms
class FileHelper {
  /// Check if a file exists (only works on non-web platforms)
  static bool fileExists(String path) {
    if (kIsWeb) {
      // On web, we can't check file existence
      return true;
    }
    try {
      final file = File(path);
      return file.existsSync();
    } catch (e) {
      return false;
    }
  }

  /// Get file size in bytes (only works on non-web platforms)
  static int getFileSize(String path) {
    if (kIsWeb) {
      // On web, we can't get file size from path
      return 0;
    }
    try {
      final file = File(path);
      return file.lengthSync();
    } catch (e) {
      return 0;
    }
  }

  /// Get file name from path
  static String getFileName(String path) {
    return path.split('/').last;
  }
}

