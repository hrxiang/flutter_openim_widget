import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sprintf/sprintf.dart';

class ChatFilePreview extends StatefulWidget {
  const ChatFilePreview({
    Key? key,
    required this.msgId,
    required this.name,
    required this.size,
    required this.available,
    // this.path,
    this.url,
    this.subject,
    this.onDownload,
  }) : super(key: key);
  final String msgId;
  final Subject<MsgStreamEv<double>>? subject;

  // final String? path;
  final String? url;
  final String name;

  ///    _isExit = (_isNotNullStr(widget.path)
  ///         ? await File(widget.path!).exists()
  ///         : false) ||
  ///         _isNotNullStr(widget.url);
  final bool available;
  final int size;
  final Function(String url)? onDownload;

  @override
  _ChatFilePreviewState createState() => _ChatFilePreviewState();
}

class _ChatFilePreviewState extends State<ChatFilePreview> {
  bool _start = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(context),
      backgroundColor: Color(0xFFF6F6F6),
      body: Stack(
        children: [
          Positioned(
            top: 136.h,
            width: 375.w,
            child: ImageUtil.assetImage(
              'ic_file_grey',
              width: 56.w,
              height: 56.h,
            ),
          ),
          Positioned(
            top: 224.h,
            width: 375.w,
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Positioned(
            top: 258.h,
            width: 375.w,
            child: Text(
              sprintf(UILocalizations.fileSize,
                  [CommonUtil.formatBytes(widget.size)]),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF333333),
              ),
            ),
          ),
          widget.available
              ? Positioned(
                  top: 496.h,
                  width: 375.w,
                  child: Container(
                    alignment: Alignment.center,
                    child: StreamBuilder(
                      stream: widget.subject?.stream,
                      builder: (_, AsyncSnapshot<MsgStreamEv<double>> hot) {
                        var event = hot.data;
                        return GestureDetector(
                          onTap: _start
                              ? null
                              : () {
                                  setState(() {
                                    _start = !_start;
                                    widget.onDownload?.call(widget.url!);
                                  });
                                },
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            width: 50.w,
                            height: 50.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  backgroundColor: Color(0xFFCCCCCC),
                                  color: Color(0xFF1D6BED),
                                  strokeWidth: 3,
                                  value: event?.value ?? 0,
                                ),
                                ImageUtil.assetImage(
                                  _start
                                      ? 'ic_download_continue'
                                      : 'ic_download_stop',
                                  width: 23.w,
                                  height: 23.h,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Positioned(
                  top: 510.h,
                  width: 375.w,
                  child: Text(
                    UILocalizations.fileUnavailable,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xFFDD000F),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

/*
class ChatFilePreview extends StatelessWidget {
  const ChatFilePreview({
    Key? key,
    required this.msgId,
    required this.name,
    required this.size,
    required this.available,
    this.path,
    this.url,
    this.subject,
    this.localizations = const UILocalizations(),
  }) : super(key: key);
  final String msgId;
  final Subject<MsgStreamEv<double>>? subject;
  final String? path;
  final String? url;
  final String name;

  ///    _isExit = (_isNotNullStr(widget.path)
  ///         ? await File(widget.path!).exists()
  ///         : false) ||
  ///         _isNotNullStr(widget.url);
  final bool available;
  final int size;
  final UILocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(context),
      backgroundColor: Color(0xFFF6F6F6),
      body: Stack(
        children: [
          Positioned(
            top: 136.h,
            width: 375.w,
            child: ChatIcon.assetImage(
              'ic_file_grey',
              width: 56.w,
              height: 56.h,
            ),
          ),
          Positioned(
            top: 224.h,
            width: 375.w,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Positioned(
            top: 258.h,
            width: 375.w,
            child: Text(
              sprintf(localizations.fileSize, [CommonUtil.formatBytes(size)]),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF333333),
              ),
            ),
          ),
          available
              ? Positioned(
                  top: 496.h,
                  width: 375.w,
                  child: Container(
                    alignment: Alignment.center,
                    child: StreamBuilder(
                      stream: subject?.stream,
                      builder: (_, AsyncSnapshot<MsgStreamEv<double>> hot) {
                        var event = hot.data;
                        if (event == null) return Container();
                        return Container(
                          width: 50.w,
                          height: 50.h,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                backgroundColor: Color(0xFFCCCCCC),
                                color: Color(0xFF1D6BED),
                                strokeWidth: 3,
                                value: event.value,
                              ),
                              ChatIcon.assetImage(
                                'ic_download_continue',
                                width: 23.w,
                                height: 23.h,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Positioned(
                  top: 510.h,
                  width: 375.w,
                  child: Text(
                    localizations.fileUnavailable,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xFFDD000F),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
*/
