import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatVoiceRecordBar extends StatefulWidget {
  const ChatVoiceRecordBar({
    Key? key,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onLongPressMoveUpdate,
  }) : super(key: key);
  final Function(LongPressStartDetails details) onLongPressStart;
  final Function(LongPressEndDetails details) onLongPressEnd;
  final Function(LongPressMoveUpdateDetails details) onLongPressMoveUpdate;

  @override
  _ChatVoiceRecordBarState createState() => _ChatVoiceRecordBarState();
}

class _ChatVoiceRecordBarState extends State<ChatVoiceRecordBar> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        setState(() {
          _pressing = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _pressing = false;
        });
      },
      onTapCancel: (){
        setState(() {
          _pressing = false;
        });
      },
      onLongPressStart: (details) {
        HapticFeedback.heavyImpact();
        widget.onLongPressStart(details);
        setState(() {
          _pressing = true;
        });
      },
      onLongPressEnd: (details) {
        widget.onLongPressEnd(details);
        setState(() {
          _pressing = false;
        });
      },
      onLongPressMoveUpdate: (details) {
        widget.onLongPressMoveUpdate(details);
        // Offset global = details.globalPosition;
        // Offset local = details.localPosition;
        // print('global:$global');
        // print('local:$local');
      },
      child: Container(
        // constraints: BoxConstraints(minHeight: 40.h),
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFF1D6BED).withOpacity(_pressing ? 0.3 : 1),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.12),
              offset: Offset(0, -1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          _pressing ? UILocalizations.releaseSend : UILocalizations.pressSpeak,
          style: TextStyle(
            fontSize: 12.sp,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
