import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

import 'at_special_text_span_builder.dart';

class ChatInputBoxView extends StatefulWidget {
  ChatInputBoxView({
    Key? key,
    required this.toolbox,
    required this.multiOpToolbox,
    required this.voiceRecordBar,
    this.allAtMap = const <String, String>{},
    this.atCallback,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.style,
    this.forceCloseToolboxSub,
    this.quoteContent,
    this.onClearQuote,
    this.multiMode = false,
  }) : super(key: key);
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final Widget toolbox;
  final Widget multiOpToolbox;
  final ChatVoiceRecordBar voiceRecordBar;
  final TextStyle? style;
  final Subject? forceCloseToolboxSub;
  final String? quoteContent;
  final Function()? onClearQuote;
  final bool multiMode;

  @override
  _ChatInputBoxViewState createState() => _ChatInputBoxViewState();
}

class _ChatInputBoxViewState extends State<ChatInputBoxView>
    with TickerProviderStateMixin {
  var _toolsVisible = false;
  var _keyboardInput = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          // controller.forward();
        }
      });

    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    widget.focusNode?.addListener(() {
      if (widget.focusNode!.hasFocus) {
        setState(() {
          _toolsVisible = false;
        });
      }
    });

    widget.forceCloseToolboxSub?.listen((value) {
      if (!mounted) return;
      setState(() {
        _toolsVisible = false;
      });
    });

    widget.controller?.addListener(() {
      if (widget.controller!.text.isEmpty) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller?.dispose();
    widget.focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.multiMode
        ? widget.multiOpToolbox
        : _buildMsgInputField(context: context);
  }

  focus() => FocusScope.of(context).requestFocus(widget.focusNode);

  unfocus() => FocusScope.of(context).requestFocus(FocusNode());

  Widget _buildMsgInputField({required BuildContext context}) => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Color(0xFFE8F2FF),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.12),
                  offset: Offset(0, -1),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _keyboardInput ? _speakBtn() : _keyboardBtn(),
                    Flexible(
                      child: Stack(
                        children: [
                          Offstage(
                            child: Column(
                              children: [
                                _buildTextFiled(),
                                if (widget.quoteContent != null &&
                                    "" != widget.quoteContent)
                                  _quoteView(),
                              ],
                            ),
                            offstage: !_keyboardInput,
                          ),
                          Offstage(
                            child: widget.voiceRecordBar,
                            offstage: _keyboardInput,
                          ),
                          // _keyboardInput ? _buildTextFiled() : _buildSpeakBar()
                        ],
                      ),
                    ),
                    _toolsBtn(),
                    Visibility(
                      visible: _keyboardInput,
                      child: Container(
                        width: 60.0 * (1.0 - _animation.value),
                        child: _buildSendButton(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: _toolsVisible,
            child: widget.toolbox,
          ),
        ],
      );

  Widget _buildSendButton() => GestureDetector(
        onTap: () {
          focus();
          if (null != widget.onSubmitted && null != widget.controller) {
            widget.onSubmitted!(widget.controller!.text.toString());
          }
        },
        child: Container(
          height: 33.h,
          width: 60.w,
          // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: Color(0xFF1B72EC),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '发送',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      );

  Widget _quoteView() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onClearQuote,
        child: Container(
          margin: EdgeInsets.only(top: 4.h),
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.quoteContent!,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12.sp,
                  ),
                ),
              ),
              ChatIcon.assetImage(
                'ic_del_quote',
                width: 14.w,
                height: 15.h,
              ),
            ],
          ),
        ),
      );

  Widget _buildTextFiled() => Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(minHeight: 35.h),
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ChatTextField(
          style: widget.style ?? textStyle,
          atCallback: widget.atCallback,
          allAtMap: widget.allAtMap,
          focusNode: widget.focusNode,
          controller: widget.controller,
          // onSubmitted: (value) {
          //   focus();
          //   if (null != widget.onSubmitted) widget.onSubmitted!(value);
          // },
        ),
      );

  static var textStyle = TextStyle(
    fontSize: 14.sp,
    color: Color(0xFF333333),
    textBaseline: TextBaseline.alphabetic,
  );

  Widget _speakBtn() => _buildBtn(
        icon: ChatIcon.speak(),
        onTap: () {
          PermissionUtil.microphone(() {
            setState(() {
              _keyboardInput = !_keyboardInput;
              _toolsVisible = false;
              unfocus();
            });
          });
        },
      );

  Widget _keyboardBtn() => _buildBtn(
        icon: ChatIcon.keyboard(),
        onTap: () {
          setState(() {
            _keyboardInput = !_keyboardInput;
            _toolsVisible = false;
            focus();
          });
        },
      );

  Widget _toolsBtn() => _buildBtn(
        icon: ChatIcon.tools(),
        onTap: () {
          setState(() {
            _toolsVisible = !_toolsVisible;
            _keyboardInput = true;
            if (_toolsVisible) {
              unfocus();
            } else {
              focus();
            }
          });
        },
      );

  Widget _buildBtn({required Widget icon, required Function() onTap}) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: icon,
        ),
      );
}

/*class ChatInputBoxView extends StatelessWidget {
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final Widget tools;
  final Widget? speakBtn;
  final Widget? keyboardBtn;
  final Widget? toolsBtn;
  final bool toolsVisible;
  final TextStyle? style;
  final Widget? quoteWidget;

  ChatInputBoxView({
    Key? key,
    required this.tools,
    this.allAtMap = const <String, String>{},
    this.atCallback,
    this.focusNode,
    this.controller,
    this.onSubmitted,
    this.toolsVisible = false,
    this.speakBtn,
    this.keyboardBtn,
    this.toolsBtn,
    this.style,
    this.quoteWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (toolsVisible) {
      unfocus(context: context);
    }
    return _buildMsgInputField(context: context);
  }

  focus({required BuildContext context}) =>
      FocusScope.of(context).requestFocus(focusNode);

  unfocus({required BuildContext context}) =>
      FocusScope.of(context).requestFocus(FocusNode());

  Widget _buildMsgInputField({required BuildContext context}) => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Color(0xFFE8F2FF),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.12),
                  offset: Offset(0, -1),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (speakBtn != null) speakBtn!,
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(minHeight: 35.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ChatTextField(
                          style: style,
                          atCallback: atCallback,
                          allAtMap: allAtMap,
                          focusNode: focusNode,
                          controller: controller,
                          onSubmitted: (value) {
                            focus(context: context);
                            if (null != onSubmitted) onSubmitted!(value);
                          },
                        ),
                      ),
                    ),
                    if (null != keyboardBtn && null != toolsBtn)
                      toolsVisible ? keyboardBtn! : toolsBtn!,
                  ],
                ),
                if (null != quoteWidget) quoteWidget!,
              ],
            ),
          ),
          Visibility(
            visible: toolsVisible,
            child: tools,
          ),
        ],
      );
}*/
