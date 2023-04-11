import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

typedef SpeakViewChildBuilder = Widget Function(ChatVoiceRecordBar recordBar);

class ChatVoiceRecordLayout extends StatefulWidget {
  const ChatVoiceRecordLayout({
    Key? key,
    required this.builder,
    this.locale,
    this.onCompleted,
    this.speakTextStyle,
    this.speakBarColor,
    this.maxRecordSec = 60,
    this.onLongPressStart,
  }) : super(key: key);

  final SpeakViewChildBuilder builder;
  final Locale? locale;
  final Function(int sec, String path)? onCompleted;
  final Color? speakBarColor;
  final TextStyle? speakTextStyle;
  final Function()? onLongPressStart;

  /// 最大记录时长s
  final int maxRecordSec;

  @override
  _ChatVoiceRecordLayoutState createState() => _ChatVoiceRecordLayoutState();
}

class _ChatVoiceRecordLayoutState extends State<ChatVoiceRecordLayout> {
  var _selectedCancelArea = false;
  var _selectedSoundToWordArea = false;
  var _selectedPressArea = true;
  var _showVoiceRecordView = false;
  var _showSpeechRecognizing = false;
  var _showRecognizeFailed = false;
  Timer? _timer;
  late VoiceRecord _record;
  String? _path;
  int _sec = 0;
  var _isInterrupt = false;

  /// 被其他事件（如：音视频通话）中断，重置状态。
  final _resetSpeakBarStatusSub = PublishSubject<bool>();

  @override
  void initState() {
    UILocalizations.set(widget.locale);
    super.initState();
  }

  void callback(int sec, String path) {
    _sec = sec;
    _path = path;
  }

  @override
  void dispose() {
    _resetSpeakBarStatusSub.close();
    if (null != _timer) {
      _timer?.cancel();
      _timer = null;
    }
    super.dispose();
  }

  ChatVoiceRecordBar _createSpeakBar() =>
      ChatVoiceRecordBar(
        speakBarColor: widget.speakBarColor,
        speakTextStyle: widget.speakTextStyle,
        resetStatusStream: _resetSpeakBarStatusSub,
        onLongPressMoveUpdate: (details) {
          Offset global = details.globalPosition;
          setState(() {
            _selectedPressArea = global.dy >= 683.h;
            _selectedCancelArea = /*global.dy >= 563.h &&*/
            global.dy < 683.h && global.dx < 172.w;
            _selectedSoundToWordArea = global.dy < 683.h && global.dx >= 172.w;
          });
        },
        onLongPressEnd: (details) async {
          if (!_isInterrupt) _stop();
        },
        onLongPressStart: (details) {
          _start();
          widget.onLongPressStart?.call();
        },
      );

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityLost: () {
        setState(() {
          _showVoiceRecordView = false;
          _selectedCancelArea = false;
          _selectedSoundToWordArea = false;
          _selectedPressArea = false;
          _showVoiceRecordView = false;
          _showSpeechRecognizing = false;
          _showRecognizeFailed = false;
          _resetSpeakBarStatusSub.add(true);
        });
      },
      child: Stack(
        children: [
          widget.builder(_createSpeakBar()),
          IgnorePointer(
            ignoring: !_showRecognizeFailed,
            child: Visibility(
              visible: _showVoiceRecordView,
              child: ChatRecordVoiceView(
                selectedCancelArea: _selectedCancelArea,
                selectedSoundToWordArea: _selectedSoundToWordArea,
                selectedPressArea: _selectedPressArea,
                showSpeechRecognizing: _showSpeechRecognizing,
                showRecognizeFailed: _showRecognizeFailed,
                onCancel: () {
                  setState(() {
                    _selectedCancelArea = false;
                    _selectedSoundToWordArea = false;
                    _selectedPressArea = true;
                    _showVoiceRecordView = false;
                    _showSpeechRecognizing = false;
                    _showRecognizeFailed = false;
                  });
                },
                onConfirm: () {
                  setState(() {
                    _callback();
                    _selectedCancelArea = false;
                    _selectedSoundToWordArea = false;
                    _selectedPressArea = true;
                    _showVoiceRecordView = false;
                    _showSpeechRecognizing = false;
                    _showRecognizeFailed = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callback() {
    if (_sec > 0 && null != _path) {
      widget.onCompleted?.call(_sec, _path!);
    }
  }

  void _stop() async {
    if (!_isInterrupt) await _record.stop();
    // 停止记录
    setState(() {
      if (_selectedPressArea) {
        _callback();
      }
      if (_selectedSoundToWordArea) {
        if (null != _timer) {
          _timer?.cancel();
          _timer = null;
        }
        _timer = new Timer(Duration(seconds: 1), () {
          setState(() {
            _showRecognizeFailed = true;
            _showSpeechRecognizing = false;
          });
        });
        _showSpeechRecognizing = true;
        _showVoiceRecordView = true;
        _selectedPressArea = false;
        _selectedCancelArea = false;
        _selectedSoundToWordArea = false;
      } else {
        _showVoiceRecordView = false;
        _selectedPressArea = false;
        _selectedCancelArea = false;
        _selectedSoundToWordArea = false;
      }
    });
  }

  void _start() {
    setState(() {
      // 开始记录
      _isInterrupt = false;
      _record = VoiceRecord(
        onFinished: (sec, path) {
          callback.call(sec, path);
        },
        onInterrupt: (sec, path) {
          _isInterrupt = true;
          callback.call(sec, path);
          _stop();
        },
        maxRecordSec: widget.maxRecordSec,
      );
      _record.start();
      _selectedPressArea = true;
      _showVoiceRecordView = true;
    });
  }
}
