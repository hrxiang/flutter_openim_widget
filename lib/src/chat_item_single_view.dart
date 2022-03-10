import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/timing_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatSingleLayout extends StatelessWidget {
  final CustomPopupMenuController popupCtrl;
  final Widget child;
  final String msgId;
  final bool isSingleChat;
  final int index;
  final Sink<int> clickSink;
  final Widget Function() menuBuilder;
  final Function()? onTapLeftAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressRightAvatar;
  final String leftAvatar;
  final String? leftName;
  final String rightAvatar;
  final double avatarSize;
  final bool isReceivedMsg;
  final bool? isUnread;
  final Color leftBubbleColor;
  final Color rightBubbleColor;
  final Stream<MsgStreamEv<bool>>? sendStatusStream;
  final bool isSendFailed;
  final bool isSending;
  final Widget? timeView;
  final Widget? quoteView;
  final bool isBubbleBg;
  final bool isHintMsg;
  final bool checked;
  final bool showRadio;
  final Function(bool checked)? onRadioChanged;
  final bool delaySendingStatus;
  final bool enabledReadStatus;
  final Function()? onStartDestroy;
  final int readingDuration;

  const ChatSingleLayout({
    Key? key,
    required this.child,
    required this.msgId,
    required this.index,
    required this.isSingleChat,
    required this.menuBuilder,
    required this.clickSink,
    required this.sendStatusStream,
    required this.popupCtrl,
    required this.isReceivedMsg,
    required this.rightAvatar,
    required this.leftAvatar,
    required this.leftName,
    this.avatarSize = 42.0,
    this.isUnread,
    this.leftBubbleColor = const Color(0xFFF0F0F0),
    this.rightBubbleColor = const Color(0xFFDCEBFE),
    this.onLongPressRightAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onTapLeftAvatar,
    this.isSendFailed = false,
    this.isSending = true,
    this.timeView,
    this.quoteView,
    this.isBubbleBg = true,
    this.isHintMsg = false,
    this.checked = false,
    this.showRadio = false,
    this.onRadioChanged,
    this.delaySendingStatus = false,
    this.enabledReadStatus = true,
    this.readingDuration = 0,
    this.onStartDestroy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showRadio ? () => onRadioChanged?.call(!checked) : null,
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        ignoring: showRadio,
        child: Row(
          // mainAxisAlignment: _layoutAlignment(),
          children: [
            if (!isHintMsg) ChatRadio(checked: checked, showRadio: showRadio),
            Expanded(
              child: Column(
                children: [
                  if (timeView != null) timeView!,
                  _buildContentView(),
                  if (quoteView != null)
                    Row(
                      mainAxisAlignment: _layoutAlignment(),
                      children: [_buildQuoteMsgView()],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView() {
    if (isHintMsg) {
      return child;
    }
    return isReceivedMsg ? _isFromWidget() : _isToWidget();
  }

  Widget _isFromWidget() => Row(
        mainAxisAlignment: _layoutAlignment(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(
            leftAvatar,
            isReceivedMsg,
            onTap: onTapLeftAvatar,
            onLongPress: onLongPressLeftAvatar,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: isReceivedMsg && !isSingleChat,
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h, left: 10.w),
                  child: Text(
                    leftName ?? '',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
              CopyCustomPopupMenu(
                controller: popupCtrl,
                barrierColor: Colors.transparent,
                arrowColor: Color(0xFF666666),
                verticalMargin: 0,
                // horizontalMargin: 0,
                child: isBubbleBg
                    ? GestureDetector(
                        onTap: () => _onItemClick?.add(index),
                        child: ChatBubble(
                          constraints: BoxConstraints(minHeight: avatarSize),
                          bubbleType: BubbleType.receiver,
                          child: child,
                          backgroundColor: _bubbleColor(),
                        ),
                      )
                    : _noBubbleBgView(),
                menuBuilder: menuBuilder,
                pressType: PressType.longPress,
              ),
            ],
          ),
        ],
      );

  Widget _isToWidget() => Row(
        mainAxisAlignment: _layoutAlignment(),
        children: [
          _buildDestroyAfterReadingView(),
          if (delaySendingStatus) _delayedStatusView(),
          if (!delaySendingStatus)
            Visibility(
              visible: isSending && !isSendFailed,
              child: CupertinoActivityIndicator(),
            ),
          ChatSendFailedView(
            msgId: msgId,
            isReceived: isReceivedMsg,
            stream: sendStatusStream,
            isSendFailed: isSendFailed,
          ),
          if (isSingleChat && !isSendFailed && !isSending && enabledReadStatus)
            _buildReadStatusView(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CopyCustomPopupMenu(
                controller: popupCtrl,
                barrierColor: Colors.transparent,
                arrowColor: Color(0xFF666666),
                verticalMargin: 0,
                // horizontalMargin: 0,
                child: isBubbleBg
                    ? GestureDetector(
                        onTap: () => _onItemClick?.add(index),
                        child: ChatBubble(
                          constraints: BoxConstraints(minHeight: avatarSize),
                          bubbleType: BubbleType.send,
                          child: child,
                          backgroundColor: _bubbleColor(),
                        ),
                      )
                    : _noBubbleBgView(),
                menuBuilder: menuBuilder,
                pressType: PressType.longPress,
              ),
              // _buildSendFailView(isReceivedMsg, fail: !isSenSuccess),
              _buildAvatar(
                rightAvatar,
                !isReceivedMsg,
                onTap: onTapRightAvatar,
                onLongPress: onLongPressRightAvatar,
              )
            ],
          ),
        ],
      );

  Widget _noBubbleBgView() => Container(
        margin: EdgeInsets.only(right: 10.w, left: 10.w),
        // padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color(0xFFE6E6E6),
            width: 1,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Color(0xFF000000).withOpacity(0.1),
          //     offset: Offset(0, 2.h),
          //     blurRadius: 4,
          //   ),
          // ],
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: child,
          ),
          onTap: () => _onItemClick?.add(index),
        ),
      );

  Sink<int>? get _onItemClick => clickSink;

  MainAxisAlignment _layoutAlignment() =>
      isReceivedMsg ? MainAxisAlignment.start : MainAxisAlignment.end;

  // BubbleNip _nip() =>
  //     isReceivedMsg ? BubbleNip.leftCenter : BubbleNip.rightCenter;

  Color _bubbleColor() => isReceivedMsg ? leftBubbleColor : rightBubbleColor;

  Widget _buildAvatar(
    String? url,
    bool show, {
    final Function()? onTap,
    final Function()? onLongPress,
  }) =>
      ChatAvatarView(
        url: url,
        visible: show,
        onTap: onTap,
        onLongPress: onLongPress,
        size: avatarSize,
      );

  Widget _buildReadStatusView() {
    bool read = !isUnread!;
    return Visibility(
      visible: !isReceivedMsg,
      child: read
          ? Text(
              UILocalizations.haveRead,
              style: haveRead,
            )
          : Text(
              UILocalizations.unread,
              style: unread,
            ),
    );
  }

  Widget _buildQuoteMsgView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      margin: EdgeInsets.only(
        left: isReceivedMsg ? avatarSize + 10.w : 0,
        right: isReceivedMsg ? 0 : avatarSize + 10.w,
        // top: 2.h,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(2),
      ),
      child: quoteView,
    );
  }

  static var haveRead = TextStyle(
    fontSize: 12.sp,
    color: Color(0xFF006AFF),
  );
  static var unread = TextStyle(
    fontSize: 12.sp,
    color: Color(0xFF999999),
  );

  Widget _delayedStatusView() => FutureBuilder(
        future: Future.delayed(
          Duration(seconds: (isSending && !isSendFailed) ? 1 : 0),
          () => isSending && !isSendFailed,
        ),
        builder: (_, AsyncSnapshot<bool> hot) => Visibility(
          visible:
              index == 0 ? (hot.data == true) : (isSending && !isSendFailed),
          child: CupertinoActivityIndicator(),
        ),
      );

  /// 阅后即焚
  Widget _buildDestroyAfterReadingView() {
    bool haveRead = !isUnread!;
    return Visibility(
      visible: haveRead && readingDuration > 0,
      child: TimingView(
        sec: readingDuration,
        onFinished: onStartDestroy,
      ),
    );
  }
}
