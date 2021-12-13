import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_emoji_view.dart';

typedef AtTextCallback = Function(String showText, String actualText);

class AtSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  final AtTextCallback? atCallback;

  /// key:userid
  /// value:username
  final Map<String, String> allAtMap;
  final TextStyle? atStyle;

  AtSpecialTextSpanBuilder({
    this.atCallback,
    this.atStyle,
    this.allAtMap = const <String, String>{},
  });

  @override
  TextSpan build(
    String data, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    StringBuffer buffer = StringBuffer();
    if (kIsWeb) {
      return TextSpan(text: data, style: textStyle);
    }
    if (allAtMap.isEmpty) {
      return TextSpan(text: data, style: textStyle);
    }
    final List<InlineSpan> children = <InlineSpan>[];

    var regexEmoji = emojiFaces.keys
        .toList()
        .join('|')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]');

    final list = [regexAt, regexEmoji];
    final pattern = '(${list.toList().join('|')})';
    final atReg = RegExp(regexAt);
    final emojiReg = RegExp(regexEmoji);

    data.splitMapJoin(
      RegExp(pattern),
      // RegExp(r"(@\S+\s)"),
      onMatch: (Match m) {
        late InlineSpan inlineSpan;
        String value = m.group(0)!;
        try {
          if (atReg.hasMatch(value)) {
            String id = value.replaceFirst("@", "").trim();
            if (allAtMap.containsKey(id)) {
              var name = allAtMap[id]!;
              inlineSpan = ExtendedWidgetSpan(
                child: Text('@$name ', style: atStyle),
                style: atStyle,
                actualText: '$value',
                start: m.start,
              );
              buffer.write('@$name ');
            } else {
              inlineSpan = TextSpan(text: '$value', style: textStyle);
              buffer.write('$value');
            }
          } else if (emojiReg.hasMatch(value)) {
            inlineSpan = ImageSpan(
              IconUtil.emojiImage(value),
              imageWidth: 20.h,
              imageHeight: 20.h,
              start: m.start,
              actualText: '$value',
            );
          }
          /*String id = value.replaceAll("@", "").trim();
        if (allAtMap.containsKey(id)) {
          var name = allAtMap[id]!;
          inlineSpan = ExtendedWidgetSpan(
            child: Text('@$name ', style: atStyle),
            style: atStyle,
            actualText: '$value',
            start: m.start,
          );
          buffer.write('@$name ');
        }*/
          else {
            /* inlineSpan = SpecialTextSpan(
            text: '${m.group(0)}',
            style: TextStyle(color: Colors.blue),
            start: m.start,
          );*/
            inlineSpan = TextSpan(text: '$value', style: textStyle);
            buffer.write('$value');
          }
        } catch (e) {
          print('error: $e');
        }
        children.add(inlineSpan);
        return "";
      },
      onNonMatch: (text) {
        children.add(TextSpan(text: text, style: textStyle));
        buffer.write(text);
        return '';
      },
    );
    if (null != atCallback) atCallback!(buffer.toString(), data);
    return TextSpan(children: children, style: textStyle);
  }

  @override
  SpecialText? createSpecialText(
    String flag, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
    required int index,
  }) {
    return null;
  }
}
