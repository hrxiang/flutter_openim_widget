import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTextField extends StatelessWidget {
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final TextStyle? style;
  final TextStyle? atStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;

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
    this.enabled = true,
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
      enabled: enabled,
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
    int end = newValue.selection.end;
    int start = oldValue.selection.baseOffset;
    if (oldValue.text.length <= newValue.text.length) {
      var newChar = newValue.text.substring(start, end);
      if (newChar == '@') {
        var result = onTap?.call();
        if (result != null) {
          var v1 = newValue.text.replaceRange(start, end, result);
          var offset = start + result.length;
          return TextEditingValue(
            text: v1,
            selection: TextSelection.collapsed(offset: offset),
          );
        }
      }
    }
    return newValue;
  }
}
