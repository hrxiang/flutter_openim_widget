import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/unread_count_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'chat_avatar_view.dart';

final pinColors = [Color(0xFF87C0FF), Color(0xFF0060E7)];
final deleteColors = [Color(0xFFFFC84C), Color(0xFFFFA93C)];
final haveReadColors = [Color(0xFFC9C9C9), Color(0xFF7A7A7A)];

class ConversationItemView extends StatelessWidget {
  final List<SlideItemInfo> slideActions;
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
  final List<MatchPattern> patterns;
  final Function()? onTap;
  final bool notDisturb;

  // final bool isPinned;

  ConversationItemView({
    Key? key,
    this.slideActions = const [],
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
    this.patterns = const [],
    this.onTap,
    this.notDisturb = false,
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
      child: _ConversationView(
        title: title,
        content: content,
        timeStr: timeStr,
        contentPrefix: contentPrefix,
        contentPrefixStyle: contentPrefixStyle,
        avatarSize: avatarSize,
        avatarUrl: avatarUrl,
        isCircleAvatar: isCircleAvatar,
        avatarBorderRadius: avatarBorderRadius,
        backgroundColor: backgroundColor,
        height: height,
        contentWidth: contentWidth,
        unreadCount: unreadCount,
        padding: padding,
        underline: underline,
        allAtMap: allAtMap,
        patterns: patterns,
        titleStyle: titleStyle,
        contentStyle: contentStyle,
        timeStyle: timeStyle,
        onTap: onTap,
        notDisturb: notDisturb,
      ),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        // extentRatio: 0.75,
        children: slideActions.map((e) => _SlidableAction(item: e)).toList(),
      ),
    );
  }
}

class _ConversationView extends StatelessWidget {
  const _ConversationView({
    Key? key,
    required this.title,
    required this.content,
    required this.timeStr,
    required this.avatarSize,
    required this.backgroundColor,
    required this.height,
    required this.contentWidth,
    required this.unreadCount,
    required this.padding,
    this.underline = true,
    required this.allAtMap,
    required this.patterns,
    // this.isPinned = false,
    required this.titleStyle,
    required this.contentStyle,
    required this.timeStyle,
    this.avatarUrl,
    this.isCircleAvatar,
    this.avatarBorderRadius,
    this.contentPrefix,
    this.contentPrefixStyle,
    this.onTap,
    this.notDisturb = false,
  }) : super(key: key);
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
  final List<MatchPattern> patterns;
  final Function()? onTap;
  final bool notDisturb;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        color: backgroundColor,
        height: height,
        padding: padding,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
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
                              bottom: BorderSide(
                                  color: Color(0xFFE5EBFF), width: 1),
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
                                patterns: patterns,
                              ),
                            ),
                            Spacer(),
                            if (!notDisturb)
                              UnreadCountView(count: unreadCount),
                            if (notDisturb) IconUtil.notDisturb(),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            if (notDisturb && unreadCount > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: avatarSize + 4,
                  height: avatarSize + 4,
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SlidableAction extends StatelessWidget {
  final SlideItemInfo item;

  const _SlidableAction({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          item.onTap?.call();
          Slidable.of(context)?.close();
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: item.boxShadow ??
                [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.5),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ],
            gradient: LinearGradient(
              colors: item.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            width: item.width,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              item.text,
              style: item.textStyle,
            ),
          ),
        ),
      ),
    );
  }
}

class SlideItemInfo {
  final String text;
  final TextStyle textStyle;
  final Function()? onTap;
  final List<Color> colors;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final int flex;

  SlideItemInfo({
    required this.text,
    required this.colors,
    this.flex = 1,
    this.onTap,
    this.width,
    this.boxShadow,
    this.textStyle = const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
  });
}