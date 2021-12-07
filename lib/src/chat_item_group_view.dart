// import 'package:bubble/bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_openim_widget/flutter_openim_widget.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class ChatGroupLayout extends StatelessWidget {
//   const ChatGroupLayout({
//     Key? key,
//     required this.child,
//     required this.msgId,
//     required this.index,
//     required this.menuBuilder,
//     required this.clickSink,
//     required this.popupCtrl,
//     required this.isReceived,
//     required this.rightAvatar,
//     // required this.rightName,
//     required this.leftAvatar,
//     required this.leftName,
//     this.avatarSize = 42.0,
//     this.leftBubbleColor = const Color(0xFFF0F0F0),
//     this.rightBubbleColor = const Color(0xFFDCEBFE),
//     this.onLongPressRightAvatar,
//     this.onTapRightAvatar,
//     this.onLongPressLeftAvatar,
//     this.onTapLeftAvatar,
//     this.sendStatusStream,
//     this.isSendFailed = false,
//     this.timeView,
//   }) : super(key: key);
//
//   final CustomPopupMenuController popupCtrl;
//   final Widget child;
//   final String msgId;
//   final int index;
//   final Sink<int> clickSink;
//   final Widget Function() menuBuilder;
//   final Function()? onTapLeftAvatar;
//   final Function()? onLongPressLeftAvatar;
//   final Function()? onTapRightAvatar;
//   final Function()? onLongPressRightAvatar;
//   final String leftAvatar;
//   final String leftName;
//   final String rightAvatar;
//   final double avatarSize;
//
//   // final String rightName;
//   final bool isReceived;
//   final Color leftBubbleColor;
//   final Color rightBubbleColor;
//   final Stream<MsgStreamEv<bool>>? sendStatusStream;
//   final bool isSendFailed;
//   final Widget? timeView;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (timeView != null) timeView!,
//         Row(
//           mainAxisAlignment: _layoutAlignment(),
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildAvatar(
//               leftAvatar,
//               isReceived,
//               onTap: onTapLeftAvatar,
//               onLongPress: onLongPressLeftAvatar,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(bottom: 2.h, left: 10.w),
//                   child: Visibility(
//                     child: Text(
//                       isReceived ? leftName : '',
//                       style: TextStyle(
//                         color: Color(0xFF666666),
//                         fontSize: 10.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ChatSendFailedView(
//                       msgId: msgId,
//                       isReceived: isReceived,
//                       stream: sendStatusStream,
//                       isSendFailed: isSendFailed,
//                     ),
//                     CopyCustomPopupMenu(
//                       controller: popupCtrl,
//                       barrierColor: Colors.transparent,
//                       arrowColor: Color(0xFF666666),
//                       verticalMargin: 0,
//                       // horizontalMargin: 0,
//                       child: Bubble(
//                         margin: BubbleEdges.only(
//                           left: isReceived ? 4.w : 0,
//                           right: isReceived ? 0 : 4.w,
//                         ),
//                         // alignment: Alignment.topRight,
//                         nip: _nip(),
//                         color: _bubbleColor(),
//                         child: InkWell(
//                           child: child,
//                           onTap: () => _onItemClick?.add(index),
//                         ),
//                       ),
//                       menuBuilder: menuBuilder,
//                       pressType: PressType.longPress,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             _buildAvatar(
//               rightAvatar,
//               !isReceived,
//               onTap: onTapRightAvatar,
//               onLongPress: onLongPressRightAvatar,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Sink<int>? get _onItemClick => clickSink;
//
//   MainAxisAlignment _layoutAlignment() =>
//       isReceived ? MainAxisAlignment.start : MainAxisAlignment.end;
//
//   BubbleNip _nip() => isReceived ? BubbleNip.leftTop : BubbleNip.rightTop;
//
//   Color _bubbleColor() => isReceived ? leftBubbleColor : rightBubbleColor;
//
//   Widget _buildAvatar(
//     String? url,
//     bool show, {
//     final Function()? onTap,
//     final Function()? onLongPress,
//   }) =>
//       ChatAvatarView(
//         url: url,
//         visible: show,
//         onTap: onTap,
//         onLongPress: onLongPress,
//         size: avatarSize,
//       );
// }
