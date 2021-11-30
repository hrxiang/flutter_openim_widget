import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/ui/widgets/unread_count_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'chat_avatar_view.dart';

final pinColors = [Color(0xFF87C0FF), Color(0xFF0060E7)];
final deleteColors = [Color(0xFFFFC84C), Color(0xFFFFA93C)];
final haveReadColors = [Color(0xFFC9C9C9), Color(0xFF7A7A7A)];

class ConversationItemView extends StatelessWidget {
  final List<SlideItemInfo>? slideActions;
  final double avatarSize;
  final String? avatarUrl;
  final bool? isCircleAvatar;
  final BorderRadius? avatarBorderRadius;
  final String title;
  final TextStyle titleStyle;
  final String content;
  final TextStyle contentStyle;
  final String? contentPrefix;
  final TextStyle? contentPrefixStyle;
  final String timeStr;
  final TextStyle timeStyle;
  final Color backgroundColor;
  final double height;
  final double contentWidth;
  final int unreadCount;
  final EdgeInsetsGeometry padding;
  final bool underline;
  final Map<String, String> allAtMap;
  final List<MatchText> parse;

  // final bool isPinned;

  ConversationItemView({
    Key? key,
    this.slideActions,
    required this.title,
    required this.content,
    required this.timeStr,
    this.contentPrefix,
    this.contentPrefixStyle,
    this.avatarSize = 48,
    this.avatarUrl,
    this.isCircleAvatar,
    this.avatarBorderRadius,
    this.backgroundColor = const Color(0xFFFFFF),
    this.height = 73,
    this.contentWidth = 200,
    this.unreadCount = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 22),
    this.underline = true,
    this.allAtMap = const {},
    this.parse = const [],
    // this.isPinned = false,
    this.titleStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFF333333),
      fontWeight: FontWeight.w600,
    ),
    this.contentStyle = const TextStyle(
      fontSize: 12,
      color: Color(0xFF666666),
      fontWeight: FontWeight.w600,
    ),
    this.timeStyle = const TextStyle(
      fontSize: 12,
      color: Color(0xFF999999),
      fontWeight: FontWeight.w600,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      child: Container(
        color: backgroundColor,
        height: height,
        padding: padding,
        child: Row(
          children: [
            ChatAvatarView(
              size: avatarSize,
              url: avatarUrl,
              isCircle: isCircleAvatar ?? true,
              borderRadius: avatarBorderRadius,
            ),
            SizedBox(width: 12.w),
            Flexible(
              child: Container(
                decoration: underline
                    ? BoxDecoration(
                        border: BorderDirectional(
                          bottom:
                              BorderSide(color: Color(0xFFE5EBFF), width: 1),
                        ),
                      )
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: contentWidth,
                          child: Text(
                            title,
                            style: titleStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Spacer(),
                        Text(
                          timeStr,
                          style: timeStyle,
                        )
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          width: contentWidth,
                          child: ChatAtText(
                            allAtMap: allAtMap,
                            text: content,
                            textStyle: contentStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            prefixSpan: null == contentPrefix
                                ? null
                                : TextSpan(
                                    text: contentPrefix,
                                    style: contentPrefixStyle,
                                  ),
                            parse: parse,
                          ),
                        ),
                        Spacer(),
                        UnreadCountView(count: unreadCount),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      secondaryActions: slideActions
          ?.map((e) => _slideAction(
                colors: e.colors,
                text: e.text,
                width: e.width,
                textStyle: e.textStyle,
                boxShadow: e.boxShadow,
                onTap: e.onTap,
              ))
          .toList(),
    );
  }

  SlideAction _slideAction({
    VoidCallback? onTap,
    required List<Color> colors,
    required String text,
    required TextStyle textStyle,
    double? width,
    List<BoxShadow>? boxShadow,
  }) =>
      SlideAction(
        onTap: onTap,
        decoration: BoxDecoration(
          boxShadow: boxShadow ??
              [
                BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.5),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                )
              ],
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      );
}

class SlideItemInfo {
  final String text;
  final TextStyle textStyle;
  final Function()? onTap;
  final List<Color> colors;
  final List<BoxShadow>? boxShadow;
  final double? width;

  SlideItemInfo({
    required this.text,
    required this.colors,
    this.onTap,
    this.width,
    this.boxShadow,
    this.textStyle = const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
  });
}
