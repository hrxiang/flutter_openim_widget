import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

class ChatInputBoxView extends StatefulWidget {
  ChatInputBoxView({
    Key? key,
    required this.toolbox,
    required this.multiOpToolbox,
    required this.voiceRecordBar,
    required this.emojiView,
    this.allAtMap = const <String, String>{},
    this.atCallback,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.style,
    this.atStyle,
    this.forceCloseToolboxSub,
    this.quoteContent,
    this.onClearQuote,
    this.multiMode = false,
    this.inputFormatters,
    this.showEmojiButton = true,
    this.showToolsButton = true,
    this.isGroupMuted = false,
    this.muteEndTime = 0,
  }) : super(key: key);
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final Widget toolbox;
  final Widget multiOpToolbox;
  final Widget emojiView;
  final ChatVoiceRecordBar voiceRecordBar;
  final TextStyle? style;
  final TextStyle? atStyle;
  final Subject? forceCloseToolboxSub;
  final String? quoteContent;
  final Function()? onClearQuote;
  final bool multiMode;
  final List<TextInputFormatter>? inputFormatters;
  final bool showEmojiButton;
  final bool showToolsButton;
  final bool isGroupMuted;
  final int muteEndTime;

  @override
  _ChatInputBoxViewState createState() => _ChatInputBoxViewState();
}

class _ChatInputBoxViewState extends State<ChatInputBoxView>
    with TickerProviderStateMixin {
  var _toolsVisible = false;
  var _emojiVisible = false;
  var _leftKeyboardButton = false;
  var _rightKeyboardButton = false;
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
          _emojiVisible = false;
          _leftKeyboardButton = false;
          _rightKeyboardButton = false;
        });
      }
    });

    widget.forceCloseToolboxSub?.listen((value) {
      if (!mounted) return;
      setState(() {
        _toolsVisible = false;
        _emojiVisible = false;
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

  EdgeInsetsGeometry get emojiButtonPadding {
    if (widget.showToolsButton) {
      return EdgeInsets.only(left: 10.w, right: 5.w);
    } else {
      return EdgeInsets.only(left: 10.w, right: 10.w);
    }
  }

  EdgeInsetsGeometry get toolsButtonPadding {
    if (widget.showEmojiButton) {
      return EdgeInsets.only(left: 5.w, right: 10.w);
    } else {
      return EdgeInsets.only(left: 10.w, right: 10.w);
    }
  }

  SizedBox get spaceView => SizedBox(
      width: widget.showEmojiButton || widget.showToolsButton ? 0 : 10.w);

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
                    _leftKeyboardButton ? _keyboardLeftBtn() : _speakBtn(),
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
                            offstage: _leftKeyboardButton,
                          ),
                          Offstage(
                            child: widget.voiceRecordBar,
                            offstage: !_leftKeyboardButton,
                          ),
                          // _keyboardInput ? _buildTextFiled() : _buildSpeakBar()
                        ],
                      ),
                    ),
                    if (widget.showEmojiButton)
                      _rightKeyboardButton ? _keyboardRightBtn() : _emojiBtn(),
                    if (widget.showToolsButton) _toolsBtn(),
                    spaceView,
                    Visibility(
                      visible: !_leftKeyboardButton || !_rightKeyboardButton,
                      child: Container(
                        width: 60.0.w * (1.0 - _animation.value),
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
          Visibility(
            visible: _emojiVisible,
            child: widget.emojiView,
          ),
        ],
      );

  Widget _buildSendButton() => GestureDetector(
        onTap: () {
          if (!_emojiVisible) focus();
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
            UILocalizations.send,
            maxLines: 1,
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
              ImageUtil.assetImage(
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
        constraints: BoxConstraints(minHeight: 40.h),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          children: [
            ChatTextField(
              style: widget.style ?? textStyle,
              atStyle: widget.atStyle ?? atStyle,
              atCallback: widget.atCallback,
              allAtMap: widget.allAtMap,
              focusNode: widget.focusNode,
              controller: widget.controller,
              enabled: !_isMuted,
              inputFormatters: widget.inputFormatters,
              // onSubmitted: (value) {
              //   focus();
              //   if (null != widget.onSubmitted) widget.onSubmitted!(value);
              // },
            ),
            Visibility(
              visible: _isMuted,
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 40.h),
                child: Text(
                  widget.isGroupMuted
                      ? UILocalizations.groupMuted
                      : UILocalizations.youMuted,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  static var textStyle = TextStyle(
    fontSize: 14.sp,
    color: Color(0xFF333333),
    textBaseline: TextBaseline.alphabetic,
  );
  static var atStyle = TextStyle(
    fontSize: 14.sp,
    color: Colors.blue,
    textBaseline: TextBaseline.alphabetic,
  );

  bool get _isMuted => widget.isGroupMuted || _isUserMuted;

  bool get _isUserMuted =>
      widget.muteEndTime > 0 ||
      widget.muteEndTime * 1000 > DateTime.now().microsecondsSinceEpoch;

  Color? get _mutedColor => _isMuted ? Color(0xFFbdbdbd) : null;

  Widget _speakBtn() => _buildBtn(
        icon: ImageUtil.speak(color: _mutedColor),
        onTap: _isMuted
            ? null
            : () {
                setState(() {
                  _leftKeyboardButton = true;
                  _rightKeyboardButton = false;
                  _toolsVisible = false;
                  _emojiVisible = false;
                  unfocus();
                });
              },
      );

  Widget _keyboardLeftBtn() => _buildBtn(
        icon: ImageUtil.keyboard(color: _mutedColor),
        onTap: _isMuted
            ? null
            : () {
                setState(() {
                  _leftKeyboardButton = false;
                  _toolsVisible = false;
                  _emojiVisible = false;
                  focus();
                });
              },
      );

  Widget _keyboardRightBtn() => _buildBtn(
        padding: emojiButtonPadding,
        // padding: EdgeInsets.only(left: 10.w, right: 5.w),
        icon: ImageUtil.keyboard(color: _mutedColor),
        onTap: _isMuted
            ? null
            : () {
                setState(() {
                  _rightKeyboardButton = false;
                  _toolsVisible = false;
                  _emojiVisible = false;
                  focus();
                });
              },
      );

  Widget _toolsBtn() => _buildBtn(
        icon: ImageUtil.tools(color: _mutedColor),
        // padding: EdgeInsets.only(left: 5.w, right: 10.w),
        padding: toolsButtonPadding,
        onTap: _isMuted
            ? null
            : () {
                setState(() {
                  _toolsVisible = !_toolsVisible;
                  _emojiVisible = false;
                  _leftKeyboardButton = false;
                  _rightKeyboardButton = false;
                  if (_toolsVisible) {
                    unfocus();
                  } else {
                    focus();
                  }
                });
              },
      );

  Widget _emojiBtn() => _buildBtn(
        padding: emojiButtonPadding,
        // padding: EdgeInsets.only(left: 10.w, right: 5.w),
        icon: ImageUtil.emoji(color: _mutedColor),
        onTap: _isMuted
            ? null
            : () {
                setState(() {
                  _rightKeyboardButton = true;
                  _leftKeyboardButton = false;
                  _emojiVisible = true;
                  _toolsVisible = false;
                  unfocus();
                });
              },
      );

  Widget _buildBtn({
    required Widget icon,
    Function()? onTap,
    EdgeInsetsGeometry? padding,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w),
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
