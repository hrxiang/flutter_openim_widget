import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

    data.splitMapJoin(
      // RegExp(r"(@[^@\s|\/|:|@]+)"),
      RegExp(r"(@\S+\s)"),
      // RegExp(r"(@[^@]+\s)"),
      onMatch: (Match m) {
        late InlineSpan inlineSpan;
        String value = m.group(0)!;
        String id = value.replaceAll("@", "").trim();
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
          /* inlineSpan = SpecialTextSpan(
            text: '${m.group(0)}',
            style: TextStyle(color: Colors.blue),
            start: m.start,
          );*/
          inlineSpan = TextSpan(text: '$value', style: textStyle);
          buffer.write('${m.group(0)}');
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
