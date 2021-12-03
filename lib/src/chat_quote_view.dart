import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
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
    if (message.contentType == MessageType.quote) {
      var quoteMessage = message.quoteElem?.quoteMessage;
      if (null != quoteMessage) {
        name = quoteMessage.senderNickName;
        if (quoteMessage.contentType == MessageType.text) {
          content = quoteMessage.content;
        } else if (quoteMessage.contentType == MessageType.picture) {
          var url1 = quoteMessage.pictureElem?.snapshotPicture?.url;
          var url2 = quoteMessage.pictureElem?.sourcePicture?.url;
          var path = quoteMessage.pictureElem?.sourcePath;
          if (url1 != null && url1.isNotEmpty) {
            child = CachedNetworkImage(
              imageUrl: url1,
              width: 42.h,
              height: 42.h,
              fit: BoxFit.fill,
            );
          } else if (url2 != null && url2.isNotEmpty) {
            child = CachedNetworkImage(
              imageUrl: url2,
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
        } else if (quoteMessage.contentType == MessageType.video) {
          var url = quoteMessage.videoElem?.snapshotUrl;
          var path = quoteMessage.videoElem?.snapshotPath;
          if (url != null && url.isNotEmpty) {
            child = _playIcon(
              child: CachedNetworkImage(
                imageUrl: url,
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
        } else if (quoteMessage.contentType == MessageType.location) {
          var location = quoteMessage.locationElem;
          if (null != location) {
            var map = _decoder.convert(location.description!);
            var url = map['url'];
            var name = map['name'];
            var addr = map['addr'];
            content = '$name($addr)';
            child = CachedNetworkImage(
              imageUrl: url,
              width: 42.h,
              height: 42.h,
              fit: BoxFit.fill,
            );
          }
        } else if (quoteMessage.contentType == MessageType.file) {}
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
          IconUtil.assetImage(
            'ic_video_play_small',
            width: 15.w,
            height: 15.h,
          ),
        ],
      );
}
