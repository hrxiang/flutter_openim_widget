import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class ChatSendFailedView extends StatefulWidget {
  final String msgId;
  final bool isReceived;
  final Stream<MsgStreamEv<bool>>? stream;
  final bool isSendFailed;

  const ChatSendFailedView({
    Key? key,
    required this.msgId,
    required this.isReceived,
    this.isSendFailed = false,
    this.stream,
  }) : super(key: key);

  @override
  _ChatSendFailedViewState createState() => _ChatSendFailedViewState();
}

class _ChatSendFailedViewState extends State<ChatSendFailedView> {
  late bool _failed;

  @override
  void initState() {
    _failed = widget.isSendFailed;
    widget.stream?.listen((event) {
      if (!mounted) return;
      if (widget.msgId == event.msgId) {
        setState(() {
          _failed = !event.value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.isReceived && _failed,
      child: ImageUtil.sendFailed(),
    );
  }
}
