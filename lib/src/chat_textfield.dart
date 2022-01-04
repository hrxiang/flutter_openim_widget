import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'at_special_text_span_builder.dart';

class ChatTextField extends StatelessWidget {
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final TextStyle? style;
  final TextStyle? atStyle;
  final List<TextInputFormatter>? inputFormatters;

  const ChatTextField({
    Key? key,
    this.allAtMap = const {},
    this.atCallback,
    this.focusNode,
    this.controller,
    this.onSubmitted,
    this.style,
    this.atStyle,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      style: style,
      specialTextSpanBuilder: AtSpecialTextSpanBuilder(
        atCallback: atCallback,
        allAtMap: allAtMap,
        atStyle: atStyle,
      ),
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.multiline,
      autofocus: false,
      minLines: 1,
      maxLines: 4,
      textInputAction: TextInputAction.newline,
      // onSubmitted: onSubmitted,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        // contentPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 8.h,
        ),
      ),
      inputFormatters: inputFormatters,
    );
  }
}

class AtTextInputFormatter extends TextInputFormatter {
  final String? Function()? onTap;

  AtTextInputFormatter(this.onTap);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    int start = oldValue.selection.baseOffset;
    if (oldValue.text.length <= newValue.text.length) {
      var curChar = newValue.text.substring(start);
      if (curChar == '@') {
        var result = onTap?.call();
        if (result != null) {
          var v1 = oldValue.text + result;
          return TextEditingValue(
            text: v1,
            selection: TextSelection.collapsed(offset: start + result.length),
          );
        }
      }
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
