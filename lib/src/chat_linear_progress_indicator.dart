import 'package:flutter/material.dart';

import 'chat_itemview.dart';

class ChatLinearProgressView extends StatefulWidget {
  /// this.show = message.status == MessageStatus.sending;
  const ChatLinearProgressView({
    Key? key,
    required this.width,
    this.height = 6,
    required this.msgId,
    this.stream,
    this.initProgress = 100,
  }) : super(key: key);

  final double width;
  final double height;
  final int initProgress;
  final String msgId;
  final Stream<MsgStreamEv<int>>? stream;

  @override
  State createState() => _ChatFileUploadProgressViewState();
}

class _ChatFileUploadProgressViewState extends State<ChatLinearProgressView> {
  int _progress = 0;

  @override
  void initState() {
    _progress = widget.initProgress;
    widget.stream?.listen((event) {
      if (!mounted) return;
      if (widget.msgId == event.msgId) {
        setState(() {
          _progress = event.value;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _progress != 100,
      child: Container(
        height: widget.height,
        width: widget.width,
        alignment: Alignment.center,
        child: LinearProgressIndicator(
          value: _progress / 100,
          backgroundColor: Colors.grey[400], // 背景色
          valueColor: AlwaysStoppedAnimation<Color>(
            Color(0xFFDCEBFE), // 进度条颜色
          ),
        ),
      ),
    );
  }
}
