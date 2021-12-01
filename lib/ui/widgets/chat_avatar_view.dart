import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<String> get indexAvatarList => [
      'ic_avatar_01',
      'ic_avatar_02',
      'ic_avatar_03',
      'ic_avatar_04',
      'ic_avatar_05',
      'ic_avatar_06',
    ];

class ChatAvatarView extends StatelessWidget {
  const ChatAvatarView({
    Key? key,
    this.visible = true,
    this.size,
    this.onTap,
    this.url,
    this.onLongPress,
    this.isCircle = true,
    this.borderRadius,
    this.text,
    this.textStyle,
  }) : super(key: key);
  final bool visible;
  final double? size;
  final Function()? onTap;
  final Function()? onLongPress;
  final String? url;
  final bool isCircle;
  final BorderRadius? borderRadius;
  final String? text;
  final TextStyle? textStyle;

  double get _size => size ?? 42.h;

  bool _isIndexAvatar() => null != url && indexAvatarList.contains(url);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child:/* isCircle
          ? ClipOval(
              child: _childAvatar(),
            )
          : */ClipRRect(
              child: _childAvatar(),
              borderRadius: borderRadius ?? BorderRadius.circular(6),
            ),
    );
  }

  Widget _childAvatar() => Container(
        width: _size,
        height: _size,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: null == url || url!.isEmpty
              ? _defaultAvatar()
              : (_isIndexAvatar()
                  ? _indexAvatar()
                  : CachedNetworkImage(
                      imageUrl: url!,
                      width: _size,
                      height: _size,
                      fit: BoxFit.fill,
                    )),
        ),
      );

  Widget _indexAvatar() => ClipOval(
        child: Container(
          width: size,
          height: size,
          child: IconUtil.assetImage(url!, width: size, height: size),
        ),
      );

  Widget _defaultAvatar() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF89C1FA),
              Color(0xFF185FD5),
            ],
          ),
        ),
        child: null == text
            ? Icon(
                Icons.person,
                color: Colors.white,
                size: _size - (_size / 4),
              )
            : Text(
                text!,
                style: textStyle ??
                    TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
        width: _size,
        height: _size,
        alignment: Alignment.center,
        // color: Colors.grey[400],
      );
}
