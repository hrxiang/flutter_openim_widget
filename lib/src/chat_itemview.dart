import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:rxdart/rxdart.dart';

class MsgStreamEv<T> {
  final String msgId;
  final T value;

  MsgStreamEv({required this.msgId, required this.value});
}

typedef CustomItemBuilder = Widget Function(
  BuildContext context,
  int index,
  Message message,
);

typedef ItemVisibilityChange = void Function(
  BuildContext context,
  int index,
  Message message,
  bool visible,
);

///  chat item
///
class ChatItemView extends StatefulWidget {
  /// if current is group chat : false
  /// if current is single chat : true
  final bool isSingleChat;

  /// When you need to customize the message style,
  /// Whether to use a bubble container
  final bool isBubbleMsg;

  /// OpenIM [Message]
  final Message message;

  ///
  // final Message? quoteMessage;

  /// Customize the display style of messages,
  /// such as system messages or status messages such as withdrawal
  final CustomItemBuilder? customItemBuilder;

  /// listview index
  final int index;

  /// Message background on the left side of the chat window
  final Color leftBubbleColor;

  /// Message background on the right side of the chat window
  final Color rightBubbleColor;

  /// Click on the message to process voice playback, video playback, picture preview, etc.
  final Subject<int> clickSubject;

  /// The status of message sending,
  /// there are two kinds of success or failure, true success, false failure
  final Subject<MsgStreamEv<bool>> msgSendStatusSubject;

  /// The progress of sending messages, such as the progress of uploading pictures, videos, and files
  final Subject<MsgStreamEv<int>> msgSendProgressSubject;

  /// Download progress of pictures, videos, and files
  // final Subject<MsgStreamEv<int>> downloadProgressSubject;

  /// Style of text content
  final TextStyle? textStyle;

  /// @ message style
  final TextStyle? atTextStyle;

  ///
  final TextStyle? urlTextStyle;

  ///
  final TextStyle? timeStyle;

  /// hint message style
  final TextStyle? hintTextStyle;

  /// Click on the avatar event on the left side of the chat window
  final Function()? onTapLeftAvatar;

  // LongPress on the avatar event on the left side of the chat window
  final Function()? onLongPressLeftAvatar;

  /// Click on the avatar event on the right side of the chat window
  final Function()? onTapRightAvatar;

  // LongPress on the avatar event on the right side of the chat window
  final Function()? onLongPressRightAvatar;

  /// Click the @ content
  final ValueChanged<String>? onClickAtText;

  ///
  // final ValueChanged<String>? onClickUrlText;

  /// Whether the current message item is visible,
  /// used to process whether the message has been read event
  final ItemVisibilityChange? visibilityChange;

  /// all user info
  /// key:userid，value:username
  final Map<String, String> allAtMap;

  // final double width;

  /// long press menu list
  final List<MenuInfo>? menus;

  /// menu list style
  final MenuStyle? menuStyle;

  ///
  final EdgeInsetsGeometry? padding;

  ///
  final EdgeInsetsGeometry? margin;

  ///
  final double? avatarSize;

  ///
  // final bool showTime;
  final String? timeStr;

  /// Click the copy button event on the menu
  final Function()? onTapCopyMenu;

  /// Click the delete button event on the menu
  final Function()? onTapDelMenu;

  /// Click the forward button event on the menu
  final Function()? onTapForwardMenu;

  /// Click the reply button event on the menu
  final Function()? onTapReplyMenu;

  /// Click the revoke button event on the menu
  final Function()? onTapRevokeMenu;

  ///
  final Function()? onTapMultiMenu;

  ///
  final Function()? onTapTranslationMenu;

  ///
  final bool multiSelMode;

  ///
  final Function(bool checked)? onMultiSelChanged;

  ///
  final List<Message> multiList;

  ///
  final Function()? onTapQuoteMsg;

  final List<MatchPattern> patterns;

  final bool delaySendingStatus;

  const ChatItemView({
    Key? key,
    required this.index,
    required this.isSingleChat,
    required this.message,
    // this.quoteMessage,
    this.customItemBuilder,
    required this.clickSubject,
    required this.msgSendStatusSubject,
    required this.msgSendProgressSubject,
    // required this.downloadProgressSubject,
    this.isBubbleMsg = false,
    // this.width = 100,
    this.leftBubbleColor = const Color(0xFFF0F0F0),
    this.rightBubbleColor = const Color(0xFFDCEBFE),
    this.onLongPressRightAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onTapLeftAvatar,
    this.visibilityChange,
    this.allAtMap = const {},
    this.onClickAtText,
    this.menus,
    this.menuStyle,
    this.padding,
    this.margin,
    this.textStyle,
    this.atTextStyle,
    this.urlTextStyle,
    this.timeStyle,
    this.hintTextStyle,
    this.avatarSize,
    // this.showTime = false,
    this.timeStr,
    this.onTapCopyMenu,
    this.onTapDelMenu,
    this.onTapForwardMenu,
    this.onTapReplyMenu,
    this.onTapRevokeMenu,
    this.onTapMultiMenu,
    this.onTapTranslationMenu,
    this.multiSelMode = false,
    this.onMultiSelChanged,
    this.multiList = const [],
    this.onTapQuoteMsg,
    this.patterns = const [],
    this.delaySendingStatus = false,
  }) : super(key: key);

  @override
  _ChatItemViewState createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  final _popupCtrl = CustomPopupMenuController();

  bool get _isFromMsg => widget.message.sendID != OpenIM.iMManager.uid;

  bool get _checked => widget.multiList.contains(widget.message);

  var _isHintMsg = false;

  var _hintTextStyle = TextStyle(
    color: Color(0xFF999999),
    fontSize: 12.sp,
  );

  @override
  void dispose() {
    _popupCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? child;
    switch (widget.message.contentType) {
      case MessageType.text:
        {
          child = _buildCommonItemView(
            child: ChatAtText(
              text: widget.message.content!,
              allAtMap: {},
              textStyle: widget.textStyle,
              patterns: widget.patterns,
            ),
          );
        }
        break;
      case MessageType.at_text:
        {
          Map map = json.decode(widget.message.content!);
          var text = map['text'];
          child = _buildCommonItemView(
            child: ChatAtText(
              text: text,
              allAtMap: widget.allAtMap,
              textStyle: widget.textStyle,
              patterns: widget.patterns,
            ),
          );
        }
        break;
      case MessageType.picture:
        {
          child = _buildCommonItemView(
            isBubbleBg: false,
            child: ChatPictureView(
              msgId: widget.message.clientMsgID!,
              isReceived: _isFromMsg,
              snapshotPath: null,
              snapshotUrl: widget.message.pictureElem?.snapshotPicture?.url,
              sourcePath: widget.message.pictureElem?.sourcePath,
              sourceUrl: widget.message.pictureElem?.sourcePicture?.url,
              width:
                  widget.message.pictureElem?.sourcePicture?.width?.toDouble(),
              height:
                  widget.message.pictureElem?.sourcePicture?.height?.toDouble(),
              widgetWidth: 100.w,
              msgSenProgressStream: widget.msgSendProgressSubject.stream,
              initMsgSendProgress: 100,
              index: widget.index,
              clickStream: widget.clickSubject.stream,
            ),
          );
        }
        break;
      case MessageType.voice:
        {
          child = _buildCommonItemView(
            child: ChatVoiceView(
              index: widget.index,
              clickStream: widget.clickSubject.stream,
              isReceived: _isFromMsg,
              soundPath: widget.message.soundElem?.soundPath,
              soundUrl: widget.message.soundElem?.sourceUrl,
              duration: widget.message.soundElem?.duration,
            ),
          );
        }
        break;
      case MessageType.video:
        {
          child = _buildCommonItemView(
            isBubbleBg: false,
            child: ChatVideoView(
              msgId: widget.message.clientMsgID!,
              isReceived: _isFromMsg,
              snapshotPath: widget.message.videoElem?.snapshotPath,
              snapshotUrl: widget.message.videoElem?.snapshotUrl,
              videoPath: widget.message.videoElem?.videoPath,
              videoUrl: widget.message.videoElem?.videoUrl,
              width: widget.message.videoElem?.snapshotWidth?.toDouble(),
              height: widget.message.videoElem?.snapshotHeight?.toDouble(),
              widgetWidth: 100.w,
              msgSenProgressStream: widget.msgSendProgressSubject.stream,
              initMsgSendProgress: 100,
              index: widget.index,
              clickStream: widget.clickSubject.stream,
            ),
          );
        }
        break;
      case MessageType.file:
        {
          child = _buildCommonItemView(
            child: ChatFileView(
              msgId: widget.message.clientMsgID!,
              fileName: widget.message.fileElem!.fileName ?? '',
              filePath: widget.message.fileElem!.filePath!,
              url: widget.message.fileElem!.sourceUrl!,
              bytes: widget.message.fileElem?.fileSize ?? 0,
              width: 158.w,
              initProgress: 100,
              uploadStream: widget.msgSendProgressSubject.stream,
              index: widget.index,
              clickStream: widget.clickSubject.stream,
            ),
          );
        }
        break;
      case MessageType.location:
        {
          child = _buildCommonItemView(
            isBubbleBg: false,
            child: ChatLocationView(
              description: widget.message.locationElem!.description!,
              latitude: widget.message.locationElem!.latitude!,
              longitude: widget.message.locationElem!.longitude!,
            ),
          );
        }
        break;
      case MessageType.quote:
        {
          child = _buildCommonItemView(
            child: ChatAtText(
              text: widget.message.quoteElem?.text ?? '',
              allAtMap: {},
              // textAlign: _isFromMsg ? TextAlign.left : TextAlign.right,
              // enabled: false,
              textStyle: widget.hintTextStyle ?? _hintTextStyle,
            ),
          );
        }
        break;

      case MessageType.merger:
        {
          child = _buildCommonItemView(
            child: ChatMergeMsgView(
              title: widget.message.mergeElem?.title ?? '',
              summaryList: widget.message.mergeElem?.abstractList ?? [],
            ),
          );
        }
        break;
      case MessageType.card:
        {
          var data = json.decode(widget.message.content!);
          child = _buildCommonItemView(
            isBubbleBg: false,
            child: ChatCarteView(
              name: data['name'],
              url: data['icon'],
            ),
          );
        }
        break;
      default:
        {
          _isHintMsg = true;
          var text;
          if (MessageType.revoke == widget.message.contentType) {
            var who = _isFromMsg
                ? widget.message.senderNickName
                : UILocalizations.you;
            text = '$who ${UILocalizations.revokeAMsg}';
          } else {
            try {
              var content = json.decode(widget.message.content!);
              text = content['defaultTips'];
            } catch (e) {
              text = json.encode(widget.message);
            }
          }
          child = _buildCommonItemView(
            isBubbleBg: false,
            isHintMsg: true,
            child: ChatAtText(
              text: text,
              allAtMap: {},
              textAlign: TextAlign.center,
              // enabled: false,
              textStyle: widget.hintTextStyle ?? _hintTextStyle,
            ),
          );
        }
        break;
    }
    var view = _customItemView();
    if (null != view) {
      if (widget.isBubbleMsg) {
        child = _buildCommonItemView(child: view);
      } else {
        child = view;
      }
    }
    return FocusDetector(
      child: Container(
        padding: widget.padding ??
            EdgeInsets.fromLTRB(
              widget.multiSelMode && !_isHintMsg ? 0 : 22.w,
              0,
              22.w,
              _isHintMsg ? 5.h : 15.h,
            ),
        margin: widget.margin,
        child: child,
      ),
      onVisibilityLost: () {
        if (widget.visibilityChange != null) {
          widget.visibilityChange!(
            context,
            widget.index,
            widget.message,
            false,
          );
        }
      },
      onVisibilityGained: () {
        if (widget.visibilityChange != null) {
          widget.visibilityChange!(
            context,
            widget.index,
            widget.message,
            true,
          );
        }
      },
    );
  }

  Widget _buildCommonItemView({
    required Widget child,
    bool isBubbleBg = true,
    bool isHintMsg = false,
  }) =>
      ChatSingleLayout(
        child: child,
        msgId: widget.message.clientMsgID!,
        index: widget.index,
        menuBuilder: _menuBuilder,
        clickSink: widget.clickSubject.sink,
        sendStatusStream: widget.msgSendStatusSubject.stream,
        popupCtrl: _popupCtrl,
        isReceivedMsg: _isFromMsg,
        isSingleChat: widget.isSingleChat,
        avatarSize: widget.avatarSize ?? 42.h,
        rightAvatar: OpenIM.iMManager.uInfo.icon!,
        leftAvatar: widget.message.senderFaceUrl!,
        leftName: widget.message.senderNickName!,
        isUnread: !widget.message.isRead!,
        leftBubbleColor: widget.leftBubbleColor,
        rightBubbleColor: widget.rightBubbleColor,
        onLongPressRightAvatar: widget.onLongPressRightAvatar,
        onTapRightAvatar: widget.onTapRightAvatar,
        onLongPressLeftAvatar: widget.onLongPressLeftAvatar,
        onTapLeftAvatar: widget.onTapLeftAvatar,
        isSendFailed: widget.message.status == MessageStatus.failed,
        isSending: widget.message.status == MessageStatus.sending,
        timeView: widget.timeStr == null ? null : _buildTimeView(),
        isBubbleBg: isBubbleBg,
        isHintMsg: isHintMsg,
        quoteView: widget.message.contentType == MessageType.quote
            ? ChatQuoteView(
                message: widget.message,
                onTap: widget.onTapQuoteMsg,
              )
            : null,
        showRadio: widget.multiSelMode,
        checked: _checked,
        onRadioChanged: widget.onMultiSelChanged,
        delaySendingStatus: widget.delaySendingStatus,
      );

  Widget _menuBuilder() => ChatLongPressMenu(
        controller: _popupCtrl,
        menus: widget.menus ?? _menusItem(),
        menuStyle: widget.menuStyle ??
            MenuStyle(
              crossAxisCount: 4,
              mainAxisSpacing: 13.w,
              crossAxisSpacing: 12.h,
              radius: 4,
              background: const Color(0xFF666666),
            ),
      );

  Widget? _customItemView() => null == widget.customItemBuilder
      ? null
      : widget.customItemBuilder!(
          context,
          widget.index,
          widget.message,
        );

  Widget _buildTimeView() => Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.h),
        // height: 20.h,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(4),
        //   color: Colors.black.withOpacity(0.2),
        // ),
        child: Text(
          widget.timeStr!,
          style: widget.timeStyle ?? _hintTextStyle,
        ),
      );

  List<MenuInfo> _menusItem() => [
        MenuInfo(
          icon: IconUtil.menuCopy(),
          text: UILocalizations.copy,
          enabled: widget.message.contentType == MessageType.text,
          textStyle: menuTextStyle,
          onTap: widget.onTapCopyMenu,
        ),
        MenuInfo(
          icon: IconUtil.menuDel(),
          text: UILocalizations.delete,
          enabled: true,
          textStyle: menuTextStyle,
          onTap: widget.onTapDelMenu,
        ),
        MenuInfo(
          icon: IconUtil.menuForward(),
          text: UILocalizations.forward,
          enabled: widget.message.contentType != MessageType.voice,
          textStyle: menuTextStyle,
          onTap: widget.onTapForwardMenu,
        ),
        MenuInfo(
          icon: IconUtil.menuReply(),
          text: UILocalizations.reply,
          enabled: widget.message.contentType == MessageType.text ||
              widget.message.contentType == MessageType.video ||
              widget.message.contentType == MessageType.picture ||
              widget.message.contentType == MessageType.location ||
              widget.message.contentType == MessageType.quote,
          textStyle: menuTextStyle,
          onTap: widget.onTapReplyMenu,
        ),
        MenuInfo(
            icon: IconUtil.menuRevoke(),
            text: UILocalizations.revoke,
            enabled: widget.message.sendID == OpenIM.iMManager.uid,
            textStyle: menuTextStyle,
            onTap: widget.onTapRevokeMenu),
        MenuInfo(
          icon: IconUtil.menuMultiChoice(),
          text: UILocalizations.multiChoice,
          enabled: true,
          textStyle: menuTextStyle,
          onTap: widget.onTapMultiMenu,
        ),
        MenuInfo(
          icon: IconUtil.menuTranslation(),
          text: UILocalizations.translation,
          enabled: widget.message.contentType == MessageType.text,
          textStyle: menuTextStyle,
          onTap: widget.onTapTranslationMenu,
        ),
    // MenuInfo(
        //   icon: IconUtil.menuDownload(),
        //   text: widget.localizations.download,
        //   enabled: true,
        //   textStyle: menuTextStyle,
        //   onTap: () {},
        // ),
      ];

  static var menuTextStyle = TextStyle(
    fontSize: 10.sp,
    color: Color(0xFFFFFFFF),
  );
}
