import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// message content: @uid1 @uid2 xxxxxxx
///

enum ChatTextModel { match, normal }

class ChatAtText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final InlineSpan? prefixSpan;

  /// isReceived ? TextAlign.left : TextAlign.right
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final double textScaleFactor;

  /// all user info
  /// key:userid
  /// value:username
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final ChatTextModel model;

  // final TextAlign textAlign;
  const ChatAtText({
    Key? key,
    required this.text,
    this.allAtMap = const <String, String>{},
    this.prefixSpan,
    this.patterns = const <MatchPattern>[],
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.textStyle,
    this.maxLines,
    this.textScaleFactor = 1.0,
    this.model = ChatTextModel.match,
  }) : super(key: key);

  static var _textStyle = TextStyle(
    fontSize: 14.sp,
    color: Color(0xFF333333),
  );

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> children = <InlineSpan>[];

    if (prefixSpan != null) children.add(prefixSpan!);

    if (model == ChatTextModel.normal) {
      _normalModel(children);
    } else {
      _matchModel(children);
    }

    return Container(
      constraints: BoxConstraints(maxWidth: 0.5.sw),
      child: RichText(
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        textScaleFactor: textScaleFactor,
        text: TextSpan(children: children),
      ),
    );
  }

  _normalModel(List<InlineSpan> children) {
    var style = textStyle ?? _textStyle;
    children.add(TextSpan(text: text, style: style));
  }

  _matchModel(List<InlineSpan> children) {
    var style = textStyle ?? _textStyle;

    final _mapping = Map<String, MatchPattern>();

    patterns.forEach((e) {
      if (e.type == PatternType.AT) {
        _mapping[regexAt] = e;
      } else if (e.type == PatternType.EMAIL) {
        _mapping[regexEmail] = e;
      } else if (e.type == PatternType.MOBILE) {
        _mapping[regexMobile] = e;
      } else if (e.type == PatternType.TEL) {
        _mapping[regexTel] = e;
      } else if (e.type == PatternType.URL) {
        _mapping[regexUrl] = e;
      } else {
        _mapping[e.pattern!] = e;
      }
    });

    var regexEmoji = emojiFaces.keys
        .toList()
        .join('|')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]');

    _mapping[regexEmoji] = MatchPattern(type: PatternType.EMOJI);

    final pattern;

    if (_mapping.length > 1) {
      pattern = '(${_mapping.keys.toList().join('|')})';
    } else {
      pattern = regexEmoji;
    }

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
          if (mapping.type == PatternType.AT) {
            String uid = matchText.replaceFirst("@", "").trim();
            value = uid;
            if (allAtMap.containsKey(uid)) {
              matchText = '@${allAtMap[uid]!} ';
            }
          }
          if (mapping.type == PatternType.EMOJI) {
            inlineSpan = ImageSpan(
              ImageUtil.emojiImage(matchText),
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
  }

  _getUrl(String text, PatternType type) {
    switch (type) {
      case PatternType.URL:
        return text.substring(0, 4) == 'http' ? text : 'http://$text';
      case PatternType.EMAIL:
        return text.substring(0, 7) == 'mailto:' ? text : 'mailto:$text';
      case PatternType.TEL:
      case PatternType.MOBILE:
        return text.substring(0, 4) == 'tel:' ? text : 'tel:$text';
      // case PatternType.PHONE:
      //   return text.substring(0, 4) == 'tel:' ? text : 'tel:$text';
      default:
        return text;
    }
  }
}

class MatchPattern {
  PatternType type;

  String? pattern;

  TextStyle? style;

  Function(String link, PatternType? type)? onTap;

  MatchPattern({required this.type, this.pattern, this.style, this.onTap});
}

enum PatternType { AT, EMAIL, MOBILE, TEL, URL, EMOJI, CUSTOM }

/// 空格@uid空格
const regexAt = r"(\s@\S+\s)";

/// Email Regex - A predefined type for handling email matching
const regexEmail = r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b";

/// URL Regex - A predefined type for handling URL matching
const regexUrl =
    r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=]*)";

/// Phone Regex - A predefined type for handling phone matching
// const regexMobile =
//     r"(\+?( |-|\.)?\d{1,2}( |-|\.)?)?(\(?\d{3}\)?|\d{3})( |-|\.)?(\d{3}( |-|\.)?\d{4})";

/// Regex of exact mobile.
const String regexMobile =
    '^(\\+?86)?((13[0-9])|(14[57])|(15[0-35-9])|(16[2567])|(17[01235-8])|(18[0-9])|(19[1589]))\\d{8}\$';

/// Regex of telephone number.
const String regexTel = '^0\\d{2,3}[-]?\\d{7,8}';
