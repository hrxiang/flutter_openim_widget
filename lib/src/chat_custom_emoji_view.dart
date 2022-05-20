import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class ChatCustomEmojiView extends StatelessWidget {
  const ChatCustomEmojiView({
    Key? key,
    this.index,
    this.data,
    this.widgetWidth = 100,
  }) : super(key: key);

  /// 内置表情包，按位置显示
  final int? index;

  /// 收藏的表情包以加载url的方式
  /// {"url:"", "width":0, "height":0 }
  final String? data;

  final double widgetWidth;

  @override
  Widget build(BuildContext context) {
    // 收藏的url表情
    try {
      if (data != null) {
        var map = json.decode(data!);
        var url = map['url'];
        var w = map['width'] ?? 1.0;
        var h = map['height'] ?? 1.0;
        if (w is int) {
          w = w.toDouble();
        }
        if (h is int) {
          h = h.toDouble();
        }
        var trulyWidth;
        var trulyHeight;
        if (widgetWidth < w) {
          trulyWidth = widgetWidth;
          trulyHeight = trulyWidth * h / w;
        } else {
          trulyWidth = w;
          trulyHeight = h;
        }

        return ImageUtil.networkImage(
          url: url,
          width: trulyWidth,
          height: trulyHeight,
          // cacheWidth: trulyWidth,
        );
      }
    } catch (e) {
      print('e:$e');
    }
    // 位置表情
    return Container();
  }
}
