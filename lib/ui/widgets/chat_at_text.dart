import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_emoji_view.dart';

/// message content: @uid1 @uid2 xxxxxxx
///
class ChatAtText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final InlineSpan? prefixSpan;

  /// isReceived ? TextAlign.left : TextAlign.right
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;

  /// all user info
  /// key:userid
  /// value:username
  final Map<String, String> allAtMap;
  final List<MatchText> parse;

  // final TextAlign textAlign;
  const ChatAtText({
    Key? key,
    required this.text,
    required this.allAtMap,
    this.prefixSpan,
    this.parse = const <MatchText>[],
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    // this.textAlign = TextAlign.start,
    this.textStyle,
    this.maxLines,
  }) : super(key: key);

  static var _textStyle = TextStyle(
    fontSize: 14.sp,
    color: Color(0xFF333333),
  );

  static var _atTextStyle = TextStyle(
    color: Color(0xFF1B72EC),
    fontSize: 14.sp,
  );

  static var _urlTextStyle = TextStyle(
    color: Color(0xFF1B72EC),
    fontSize: 14.sp,
    decoration: TextDecoration.underline,
  );

  static var _linkTextStyle = TextStyle(
    color: Color(0xFF1B72EC),
    fontSize: 14.sp,
  );

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> children = <InlineSpan>[];

    if (prefixSpan != null) children.add(prefixSpan!);

    var style = textStyle ?? _textStyle;

    final _mapping = Map<String, MatchText>();

    parse.forEach((e) {
      if (e.type == ParsedType.AT) {
        _mapping[atPattern] = e;
      } else if (e.type == ParsedType.EMAIL) {
        _mapping[emailPattern] = e;
      } else if (e.type == ParsedType.PHONE) {
        _mapping[phonePattern] = e;
      } else if (e.type == ParsedType.URL) {
        _mapping[urlPattern] = e;
      } else {
        _mapping[e.pattern!] = e;
      }
    });

    var emojiPattern = emojiFaces.keys
        .toList()
        .join('|')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]');

    _mapping[emojiPattern] = MatchText(type: ParsedType.EMOJI);

    final pattern = '(${_mapping.keys.toList().join('|')})';

    // match  text
    text.splitMapJoin(
      RegExp(pattern),
      onMatch: (Match match) {
        var matchText = match[0]!;
        var value = matchText;
        var inlineSpan;
        final mapping = _mapping[matchText] ??
            _mapping[_mapping.keys.firstWhere((element) {
              final reg = RegExp(element);
              return reg.hasMatch(matchText);
            }, orElse: () {
              return '';
            })];
        if (mapping != null) {
          if (mapping.type == ParsedType.AT) {
            String uid = matchText.replaceAll("@", "").trim();
            value = uid;
            if (allAtMap.containsKey(uid)) {
              matchText = '@${allAtMap[uid]!} ';
            }
          }
          if (mapping.type == ParsedType.EMOJI) {
            inlineSpan = ImageSpan(
              IconUtil.emojiImage(matchText),
              imageWidth: 20.h,
              imageHeight: 20.h,
            );
          } else {
            inlineSpan = TextSpan(
              text: "$matchText",
              style: mapping.style != null ? mapping.style : style,
              recognizer: mapping.onTap == null
                  ? null
                  : (TapGestureRecognizer()
                    ..onTap = () => mapping.onTap!(
                        _getUrl(value, mapping.type), mapping.type)),
            );
          }
        } else {
          inlineSpan = TextSpan(text: "$matchText", style: style);
        }
        children.add(inlineSpan);
        return '';
      },
      onNonMatch: (text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );

    return Container(
      constraints: BoxConstraints(maxWidth: 0.5.sw),
      child: RichText(
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        text: TextSpan(children: children),
      ),
    );
  }

  _getUrl(String text, ParsedType type) {
    switch (type) {
      case ParsedType.URL:
        return text.substring(0, 4) == 'http' ? text : 'http://$text';
      case ParsedType.EMAIL:
        return text.substring(0, 7) == 'mailto:' ? text : 'mailto:$text';
      case ParsedType.PHONE:
        return text.substring(0, 4) == 'tel:' ? text : 'tel:$text';
      default:
        return text;
    }
  }
}

class MatchText {
  ParsedType type;

  String? pattern;

  TextStyle? style;

  Function(String link, ParsedType? type)? onTap;

  MatchText({required this.type, this.pattern, this.style, this.onTap});
}

enum ParsedType { AT, EMAIL, PHONE, URL, EMOJI, CUSTOM }

/// @uid
const atPattern = r"(@\S+\s)";

/// Email Regex - A predefined type for handling email matching
const emailPattern = r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b";

/// URL Regex - A predefined type for handling URL matching
const urlPattern =
    r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=]*)";

/// Phone Regex - A predefined type for handling phone matching
// const phonePattern =
//     r"(\+?( |-|\.)?\d{1,2}( |-|\.)?)?(\(?\d{3}\)?|\d{3})( |-|\.)?(\d{3}( |-|\.)?\d{4})";
// const phonePattern =
//     r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$';
const phonePattern =
    r'^(?:\+?86)?1(?:3\d{3}|5[^4\D]\d{2}|8\d{3}|7(?:[0-35-9]\d{2}|4(?:0\d|1[0-2]|9\d))|9[0-35-9]\d{2}|6[2567]\d{2}|4(?:(?:10|4[01])\d{3}|[68]\d{4}|[579]\d{2}))\d{6}$';
