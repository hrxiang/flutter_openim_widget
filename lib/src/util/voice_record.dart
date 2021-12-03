import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'permission_util.dart';

typedef RecordFc = Function(int sec, String path);

class VoiceRecord {
  static const _dir = "voice";
  static const _ext = ".m4a";
  late String _path;
  int _long = 0;
  late int _tag;
  RecordFc callback;
  final _audioRecorder = Record();

  VoiceRecord(this.callback) : _tag = DateTime.now().millisecondsSinceEpoch;

  start() {
    PermissionUtil.microphone(() async {
      var path = (await getApplicationDocumentsDirectory()).path;
      _path = '$path/$_dir/$_tag$_ext';
      File file = File(_path);
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      _long = _now();
      _audioRecorder.start(path: _path);
    });
  }

  stop() async {
    _long = (_now() - _long) ~/ 1000;
    bool isRecording = await _audioRecorder.isRecording();
    if (isRecording) {
      _audioRecorder.stop();
      callback(_long, _path);
    }
  }

  int _now() => DateTime.now().millisecondsSinceEpoch;
}
