import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// message content: @uid1 @uid2 xxxxxxx
///
class ChatAtText extends StatelessWidget {
  final String text;
  final String? prefixText;
  final TextStyle? atTextStyle;
  final TextStyle? textStyle;
  final TextStyle? prefixTextStyle;
  final ValueChanged<String>? onClickAt;

  /// isReceived ? TextAlign.left : TextAlign.right
  final TextAlign textAlign;
  final TextOverflow overflow;
  final bool enabled;

  /// all user info
  /// key:userid
  /// value:username
  final Map<String, String> allAtMap;

  // final TextAlign textAlign;
  const ChatAtText({
    Key? key,
    required this.text,
    required this.allAtMap,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.prefixText,
    this.onClickAt,
    this.enabled = false,
    // this.textAlign = TextAlign.start,
    this.textStyle,
    this.atTextStyle,
    this.prefixTextStyle,
  }) : super(key: key);

  static var _textStyle = TextStyle(
    fontSize: 14.sp,
    color: Color(0xFF333333),
  );

  static var _atTextStyle = TextStyle(
    color: Color(0xFF1B72EC),
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> children = <InlineSpan>[];
    if (prefixText != null && "" != prefixText) {
      children.add(TextSpan(text: prefixText, style: prefixTextStyle));
    }
    if (enabled) {
      text.splitMapJoin(
        RegExp(r"(@[^@]+\s)"),
        onMatch: (Match m) {
          late InlineSpan inlineSpan;
          String uid = m.group(0)!.replaceAll("@", "").trim();
          if (allAtMap.containsKey(uid)) {
            var name = allAtMap[uid]!;
            inlineSpan = WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  print('click:$uid');
                  if (null != onClickAt) onClickAt!(uid);
                },
                behavior: HitTestBehavior.translucent,
                child: Text('@$name ', style: atTextStyle ?? _atTextStyle),
              ),
            );
          } else {
            inlineSpan =
                TextSpan(text: '${m.group(0)}', style: textStyle ?? _textStyle);
          }
          children.add(inlineSpan);
          return m.group(0)!;
        },
        onNonMatch: (text) {
          children.add(TextSpan(text: text, style: textStyle ?? _textStyle));
          return text;
        },
      );
    } else {
      children.add(TextSpan(text: text, style: textStyle ?? _textStyle));
    }
    return Container(
      constraints: BoxConstraints(maxWidth: 0.5.sw),
      child: RichText(
        textAlign: textAlign,
        overflow: overflow,
        text: TextSpan(children: children),
      ),
    );
  }
}
