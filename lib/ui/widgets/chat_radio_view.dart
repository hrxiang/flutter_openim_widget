import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRadio extends StatelessWidget {
  const ChatRadio({
    Key? key,
    this.checked = false,
    this.showRadio = false,
  }) : super(key: key);
  final bool checked;
  final bool showRadio;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showRadio,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          child: IconUtl.assetImage(
            checked ? 'ic_radio_msg_sel' : 'ic_radio_msg_nor',
            width: 22.w,
            height: 22.h,
          ),
        ),
      ),
    );
  }
}
