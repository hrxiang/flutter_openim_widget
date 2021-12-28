import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_linear_progress_indicator.dart';

/*
class ChatFileView extends StatefulWidget {
  const ChatFileView({
    Key? key,
    required this.msgId,
    required this.fileName,
    required this.bytes,
    required this.index,
    required this.filePath,
    required this.url,
    this.clickStream,
    this.width = 158,
    this.initProgress = 100,
    this.uploadStream,
  }) : super(key: key);
  final String msgId;
  final String fileName;
  final String filePath;
  final String url;
  final int index;
  final Stream<int>? clickStream;
  final int bytes;
  final int initProgress;
  final Stream<MsgStreamEv<int>>? uploadStream;
  final double width;


  @override
  _ChatFileViewState createState() => _ChatFileViewState();
}

class _ChatFileViewState extends State<ChatFileView> {
  @override
  void initState() {
   */
/* widget.clickStream?.listen((i) {
      if (!mounted) return;
      if (_isClickedLocation(i)) {
        if (null != widget.onClickFile) {
          widget.onClickFile!(widget.url, widget.filePath);
        }
      }
    });*/ /*

    super.initState();
  }

  bool _isClickedLocation(i) => i == widget.index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      // height: 70.h,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fileName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Text(
                      CommonUtil.formatBytes(widget.bytes),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Color(0xFF777777),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              ChatIcon.file(),
            ],
          ),
          ChatLinearProgressView(
            width: widget.width,
            height: 10.h,
            msgId: widget.msgId,
            initProgress: widget.initProgress,
            stream: widget.uploadStream,
          ),
        ],
      ),
    );
  }
}
*/

class ChatFileView extends StatelessWidget {
  const ChatFileView({
    Key? key,
    required this.msgId,
    required this.fileName,
    required this.bytes,
    required this.index,
    // required this.filePath,
    // required this.url,
    this.clickStream,
    this.width = 158,
    this.initProgress = 100,
    this.uploadStream,
  }) : super(key: key);
  final String msgId;
  final String fileName;
  final int bytes;
  final int initProgress;
  final Stream<MsgStreamEv<int>>? uploadStream;
  final double width;
  // final String filePath;
  // final String url;
  final int index;
  final Stream<int>? clickStream;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width,
      // height: 70.h,
      constraints: BoxConstraints(maxWidth: 140.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Text(
                      CommonUtil.formatBytes(bytes),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Color(0xFF666666),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              IconUtil.file(),
            ],
          ),
          ChatLinearProgressView(
            width: width,
            height: 10.h,
            msgId: msgId,
            initProgress: initProgress,
            stream: uploadStream,
          ),
        ],
      ),
    );
  }
}
