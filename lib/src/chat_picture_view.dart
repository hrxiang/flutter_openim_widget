import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class ChatPictureView extends StatefulWidget {
  const ChatPictureView({
    Key? key,
    required this.msgId,
    required this.index,
    this.clickStream,
    required this.isReceived,
    this.snapshotPath,
    this.snapshotUrl,
    this.sourcePath,
    this.sourceUrl,
    this.width,
    this.height,
    this.widgetWidth = 100,
    this.msgSenProgressStream,
    this.initMsgSendProgress = 100,
  }) : super(key: key);
  final int index;
  final Stream<int>? clickStream;
  final String? sourcePath;
  final String? sourceUrl;
  final String? snapshotPath;
  final String? snapshotUrl;
  final double? width;
  final double? height;
  final double widgetWidth;
  final String msgId;
  final Stream<MsgStreamEv<int>>? msgSenProgressStream;
  final int initMsgSendProgress;
  final bool isReceived;

  @override
  _ChatPictureViewState createState() => _ChatPictureViewState();
}

class _ChatPictureViewState extends State<ChatPictureView> {
  String? _sourcePath;
  String? _sourceUrl;

  // String? _snapshotPath;
  String? _snapshotUrl;
  late double _trulyWidth;
  late double _trulyHeight;

  @override
  void initState() {
    _sourcePath = widget.sourcePath;
    _sourceUrl = widget.sourceUrl;
    _snapshotUrl = widget.snapshotUrl;
    // _snapshotPath = widget.snapshotPath;
    var w = widget.width ?? 1.0;
    var h = widget.height ?? 1.0;

    _trulyWidth = widget.widgetWidth;
    _trulyHeight = _trulyWidth * h / w;
    /*if (widget.widgetWidth > w) {
      _trulyWidth = w;
      _trulyHeight = h;
    } else {
      _trulyWidth = widget.widgetWidth;
      _trulyHeight = _trulyWidth * h / w;
    }*/

    //
    /*if (!_isNotNull(_snapshotPath) && _isNotNull(_sourcePath)) {
      CommonUtil.createThumbnail(
        path: _sourcePath!,
        minWidth: _trulyWidth,
        minHeight: _trulyHeight,
      ).then((path) {
        if (!mounted) return;
        if (null != path) {
          setState(() {
            _snapshotPath = path;
          });
        }
      });
    }*/
    //
    /* widget.clickStream?.listen((i) {
      if (!mounted) return;
      if (_isClickedLocation(i)) {
        if (null != widget.onClickPic) {
          widget.onClickPic!(_sourceUrl, _sourcePath, _tag);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return PicturePreview(
                  url: _sourceUrl!,
                  tag: _tag!,
                  localizations: widget.localizations,
                );
              },
            ),
          );
        }
      }
    });*/
    super.initState();
  }

  bool _isClickedLocation(i) => i == widget.index;

  Widget _urlView({required String url}) => ImageUtil.networkImage(
        url: url,
        height: _trulyHeight,
        width: _trulyWidth,
        fit: BoxFit.fitWidth,
      );

  Widget _pathView({required String path}) => Stack(
        children: [
          Image(
            image: FileImage(File(path)),
            height: _trulyHeight,
            width: _trulyWidth,
            fit: BoxFit.fitWidth,
            errorBuilder: (_, error, stack) => _errorIcon(),
          ),
          ChatSendProgressView(
            height: _trulyHeight,
            width: _trulyWidth,
            msgId: widget.msgId,
            stream: widget.msgSenProgressStream,
            initProgress: widget.initMsgSendProgress,
          ),
        ],
      );

  Widget _buildChildView() {
    Widget? child;
    // if (_isNotNull(_snapshotUrl)) {
    //   child = _urlView(url: _snapshotUrl!);
    // } else if (_isNotNull(_sourceUrl)) {
    //   child = _urlView(url: _sourceUrl!);
    // } else if (_isNotNull(_snapshotPath) && File(_snapshotPath!).existsSync()) {
    //   child = _pathView(path: _snapshotPath!);
    // } else if (_isNotNull(_sourcePath) && File(_sourcePath!).existsSync()) {
    //   child = _pathView(path: _sourcePath!);
    // }
    if (widget.isReceived) {
      if (_isNotNull(_snapshotUrl)) {
        child = _urlView(url: _snapshotUrl!);
      } else if (_isNotNull(_sourceUrl)) {
        child = _urlView(url: _sourceUrl!);
      }
    } else {
      /*if (_isNotNull(_snapshotPath) && File(_snapshotPath!).existsSync()) {
        child = _pathView(path: _snapshotPath!);
      } else*/
      if (_isNotNull(_sourcePath) && File(_sourcePath!).existsSync()) {
        child = _pathView(path: _sourcePath!);
      } else if (_isNotNull(_snapshotUrl)) {
        child = _urlView(url: _snapshotUrl!);
      } else if (_isNotNull(_sourceUrl)) {
        child = _urlView(url: _sourceUrl!);
      }
    }
    return Container(child: child ?? _errorIcon());
  }

  @override
  Widget build(BuildContext context) {
    var child = _buildChildView();
    // return child;
    return Hero(tag: widget.msgId, child: child);
  }

  Widget _errorIcon() =>
      ImageUtil.error(width: _trulyWidth, height: _trulyHeight);

  static bool _isNotNull(String? value) =>
      null != value && value.trim().isNotEmpty;
}
