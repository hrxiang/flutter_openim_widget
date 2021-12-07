import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum BubbleType {
  send,
  receiver,
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    this.constraints,
    this.backgroundColor,
    this.child,
    required this.bubbleType,
  }) : super(key: key);
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final Widget? child;
  final BubbleType bubbleType;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      margin: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 2.h),
      padding: EdgeInsets.symmetric(
        horizontal: 7.w,
        vertical: 7.h,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bubbleType == BubbleType.send ? 8 : 1),
          topRight: Radius.circular(bubbleType == BubbleType.send ? 1 : 8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: child,
    );
  }
}
