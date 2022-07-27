import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatQuoteView extends StatelessWidget {
  ChatQuoteView({Key? key, required this.message, this.onTap})
      : super(key: key);
  final Message message;
  final Function()? onTap;
  final _decoder = JsonDecoder();

  @override
  Widget build(BuildContext context) {
    var child;
    var name;
    var content;
    name = message.senderNickname;
    if (message.contentType == MessageType.text) {
      content = message.content;
    } else if (message.contentType == MessageType.picture) {
      var url1 = message.pictureElem?.snapshotPicture?.url;
      var url2 = message.pictureElem?.sourcePicture?.url;
      var path = message.pictureElem?.sourcePath;
      if (url1 != null && url1.isNotEmpty) {
        child = ImageUtil.networkImage(
          url: url1,
          width: 42.h,
          height: 42.h,
          fit: BoxFit.fill,
        );
      } else if (url2 != null && url2.isNotEmpty) {
        child = ImageUtil.networkImage(
          url: url2,
          width: 42.h,
          height: 42.h,
          fit: BoxFit.fill,
        );
      } else if (path != null && path.isNotEmpty) {
        child = Image(
          image: FileImage(File(path)),
          height: 42.h,
          width: 42.h,
          fit: BoxFit.fill,
        );
      }
    } else if (message.contentType == MessageType.video) {
      var url = message.videoElem?.snapshotUrl;
      var path = message.videoElem?.snapshotPath;
      if (url != null && url.isNotEmpty) {
        child = _playIcon(
          child: ImageUtil.networkImage(
            url: url,
            width: 42.h,
            height: 42.h,
            fit: BoxFit.fill,
          ),
        );
      } else if (path != null && path.isNotEmpty) {
        child = _playIcon(
          child: Image(
            image: FileImage(File(path)),
            height: 42.h,
            width: 42.h,
            fit: BoxFit.fill,
          ),
        );
      }
    } else if (message.contentType == MessageType.location) {
      var location = message.locationElem;
      if (null != location) {
        var map = _decoder.convert(location.description!);
        var url = map['url'];
        var name = map['name'];
        var addr = map['addr'];
        content = '$name($addr)';
        child = ImageUtil.networkImage(
          url: url,
          width: 42.h,
          height: 42.h,
          fit: BoxFit.fill,
        );
      }
    } else if (message.contentType == MessageType.file) {}

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 150.w),
              child: ChatAtText(
                text: '$name：${content ?? ''}',
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  color: Color(0xFF666666),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              // child: Text(
              //   '$name：${content ?? ''}',
              //   style: TextStyle(
              //     fontSize: 12.sp,
              //     color: Color(0xFF666666),
              //   ),
              // ),
            ),
            Container(
              child: child,
            )
          ],
        ),
      ),
    );
  }

  Widget _playIcon({required Widget child}) => Stack(
        alignment: Alignment.center,
        children: [
          child,
          ImageUtil.assetImage(
            'ic_video_play_small',
            width: 15.w,
            height: 15.h,
          ),
        ],
      );
}

/*
class ChatQuoteView extends StatelessWidget {
  ChatQuoteView({Key? key, required this.message, this.onTap})
      : super(key: key);
  final Message message;
  final Function()? onTap;
  final _decoder = JsonDecoder();

  @override
  Widget build(BuildContext context) {
    var child;
    var name;
    var content;
    if (message.contentType == MessageType.quote) {
      var message = message.quoteElem?.message;
      if (null != message) {
        name = message.senderNickname;
        if (message.contentType == MessageType.text) {
          content = message.content;
        } else if (message.contentType == MessageType.picture) {
          var url1 = message.pictureElem?.snapshotPicture?.url;
          var url2 = message.pictureElem?.sourcePicture?.url;
          var path = message.pictureElem?.sourcePath;
          if (url1 != null && url1.isNotEmpty) {
            child = ImageUtil.networkImage(
              url: url1,
              width: 42.h,
              height: 42.h,
              fit: BoxFit.fill,
            );
          } else if (url2 != null && url2.isNotEmpty) {
            child = ImageUtil.networkImage(
              url: url2,
              width: 42.h,
              height: 42.h,
              fit: BoxFit.fill,
            );
          } else if (path != null && path.isNotEmpty) {
            child = Image(
              image: FileImage(File(path)),
              height: 42.h,
              width: 42.h,
              fit: BoxFit.fill,
            );
          }
        } else if (message.contentType == MessageType.video) {
          var url = message.videoElem?.snapshotUrl;
          var path = message.videoElem?.snapshotPath;
          if (url != null && url.isNotEmpty) {
            child = _playIcon(
              child: ImageUtil.networkImage(
                url: url,
                width: 42.h,
                height: 42.h,
                fit: BoxFit.fill,
              ),
            );
          } else if (path != null && path.isNotEmpty) {
            child = _playIcon(
              child: Image(
                image: FileImage(File(path)),
                height: 42.h,
                width: 42.h,
                fit: BoxFit.fill,
              ),
            );
          }
        } else if (message.contentType == MessageType.location) {
          var location = message.locationElem;
          if (null != location) {
            var map = _decoder.convert(location.description!);
            var url = map['url'];
            var name = map['name'];
            var addr = map['addr'];
            content = '$name($addr)';
            child = ImageUtil.networkImage(
              url: url,
              width: 42.h,
              height: 42.h,
              fit: BoxFit.fill,
            );
          }
        } else if (message.contentType == MessageType.file) {}
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 150.w),
              child: Text(
                '$name：${content ?? ''}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            Container(
              child: child,
            )
          ],
        ),
      ),
    );
  }

  Widget _playIcon({required Widget child}) => Stack(
    alignment: Alignment.center,
    children: [
      child,
      ImageUtil.assetImage(
        'ic_video_play_small',
        width: 15.w,
        height: 15.h,
      ),
    ],
  );
}*/
