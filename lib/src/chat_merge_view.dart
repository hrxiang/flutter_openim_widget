import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMergeMsgView extends StatelessWidget {
  const ChatMergeMsgView(
      {Key? key, required this.title, required this.summaryList})
      : super(key: key);
  final String title;
  final List<String> summaryList;

  List<Widget> _children() {
    var list = <Widget>[];
    list
      ..add(Text(
        title,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 15.sp,
        ),
      ))
      ..add(Padding(
        padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
        child: Divider(
          color: Color(0xFFD8D8D8),
          height: 0.5.h,
        ),
      ));
    for (var s in summaryList) {
      list.add(Text(
        s.trim(),
        style: TextStyle(
          color: Color(0xFF666666),
          fontSize: 11.sp,
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 200.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _children(),
      ),
    );
  }
}
