import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';

late String imCachePath;

class CommonUtil {
  /// path: image path
  static Future<String?> createThumbnail({
    required String path,
    required double minWidth,
    required double minHeight,
  }) async {
    if (!(await File(path).exists())) {
      return null;
    }
    String thumbPath = await createTempPath(path, flag: 'im');
    File destFile = File(thumbPath);
    if (!(await destFile.exists())) {
      await destFile.create(recursive: true);
    } else {
      return thumbPath;
    }
    var compressFile = await compressImage(
      File(path),
      targetPath: thumbPath,
      minHeight: minHeight ~/ 1,
      minWidth: minWidth ~/ 1,
    );
    return compressFile?.path;
  }

  static Future<String> createTempPath(
    String sourcePath, {
    String flag = "",
    String dir = 'pic',
  }) async {
    var path = (await getApplicationDocumentsDirectory()).path;
    var name =
        '${flag}_${sourcePath.substring(sourcePath.lastIndexOf('/') + 1)}';
    String dest = '$path/$dir/$name';

    return dest;
  }

  /// get Now Date Milliseconds.
  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  ///  compress file and get file.
  static Future<File?> compressImage(
    File? file, {
    required String targetPath,
    required int minWidth,
    required int minHeight,
  }) async {
    if (null == file) return null;
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/"));
    // var ext = name.substring(name.lastIndexOf("."));
    CompressFormat format = CompressFormat.jpeg;
    if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
      format = CompressFormat.jpeg;
    } else if (name.endsWith(".png")) {
      format = CompressFormat.png;
    } else if (name.endsWith(".heic")) {
      format = CompressFormat.heic;
    } else if (name.endsWith(".webp")) {
      format = CompressFormat.webp;
    }

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      inSampleSize: 2,
      minWidth: minWidth,
      minHeight: minHeight,
      format: format,
    );
    return result;
  }

  //fileExt 文件后缀名
  static String? getMediaType(final String filePath) {
    var fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    var fileExt = fileName.substring(fileName.lastIndexOf("."));
    switch (fileExt.toLowerCase()) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return "image/jpeg";
      case ".png":
        return "image/png";
      case ".bmp":
        return "image/bmp";
      case ".gif":
        return "image/gif";
      case ".json":
        return "application/json";
      case ".svg":
      case ".svgz":
        return "image/svg+xml";
      case ".mp3":
        return "audio/mpeg";
      case ".mp4":
        return "video/mp4";
      case ".mov":
        return "video/mov";
      case ".htm":
      case ".html":
        return "text/html";
      case ".css":
        return "text/css";
      case ".csv":
        return "text/csv";
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return "text/plain";
    }
    return null;
  }

  /// 将字节数转化为MB
  static String formatBytes(int bytes) {
    int kb = 1024;
    int mb = kb * 1024;
    int gb = mb * 1024;
    if (bytes >= gb) {
      return sprintf("%.1f GB", [bytes / gb]);
    } else if (bytes >= mb) {
      double f = bytes / mb;
      return sprintf(f > 100 ? "%.0f MB" : "%.1f MB", [f]);
    } else if (bytes > kb) {
      double f = bytes / kb;
      return sprintf(f > 100 ? "%.0f KB" : "%.1f KB", [f]);
    } else {
      return sprintf("%d B", [bytes]);
    }
  }
}
