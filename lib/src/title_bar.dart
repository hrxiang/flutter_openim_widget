import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(height);

  const TitleBar({
    Key? key,
    this.result,
    this.height = 56.0,
    this.elevation = 0.0,
    this.left,
    this.center,
    this.right,
    this.shadowColor,
    this.backgroundColor,
    this.onBack,
  }) : super(key: key);
  final dynamic result;
  final double height;
  final double elevation;
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Color? shadowColor;
  final Color? backgroundColor;
  final Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return _appbar(
      data: result,
      height: height,
      elevation: elevation,
      shadowColor: shadowColor,
      backgroundColor: backgroundColor,
      onBack: onBack,
      left: left,
      center: center,
      right: right,
    );
  }

  TitleBar.back(
    BuildContext context, {
    String? title,
    TextStyle textStyle = const TextStyle(
      fontSize: 18.0,
      color: Color(0xFF333333),
    ),
    dynamic result,
    double height = 56.0,
    double elevation = 0.0,
    Widget? right,
    Widget? center,
    Color? shadowColor,
    Color backgroundColor = Colors.white,
  })  : result = result,
        height = height,
        elevation = elevation,
        backgroundColor = backgroundColor,
        shadowColor = shadowColor,
        onBack = null,
        left = GestureDetector(
          onTap: () => Navigator.pop(context, result),
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: ImageUtil.back(),
          ),
        ),
        right = right,
        center = center ??
            Text(
              title ?? '',
              style: textStyle,
            );

  TitleBar.leftTitle({
    String? title,
    TextStyle textStyle = const TextStyle(
      fontSize: 18.0,
      color: Color(0xFF333333),
    ),
    dynamic result,
    double height = 56.0,
    double elevation = 0.0,
    Widget? right,
    Color? shadowColor,
    Color backgroundColor = Colors.white,
  })  : result = result,
        height = height,
        elevation = elevation,
        backgroundColor = backgroundColor,
        shadowColor = shadowColor,
        onBack = null,
        center = null,
        right = right,
        left = Container(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            title ?? '',
            style: textStyle,
          ),
        );

  TitleBar.imTitle({
    String? title,
    TextStyle textStyle = const TextStyle(
      fontSize: 22.0,
      color: Color(0xFF1B72EC),
    ),
    dynamic result,
    double height = 56.0,
    double elevation = 0.0,
    Color? shadowColor,
    Color backgroundColor = Colors.white,
    Function()? onSearch,
    List<PopMenuInfo> menus = const [],
  })  : result = result,
        height = height,
        elevation = elevation,
        backgroundColor = backgroundColor,
        shadowColor = shadowColor,
        onBack = null,
        center = null,
        right = Container(
          padding: EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: null != onSearch,
                child: GestureDetector(
                  onTap: onSearch,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ImageUtil.search(),
                  ),
                ),
              ),
              Visibility(
                visible: menus.length > 0,
                child: PopButton(
                  menus: menus,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ImageUtil.add(),
                  ),
                ),
              ),
            ],
          ),
        ),
        left = Container(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            title ?? '',
            style: textStyle,
          ),
        );

  static AppBar _appbar({
    dynamic data,
    double height = 56,
    double elevation = 0,
    Color? shadowColor,
    Color? backgroundColor = Colors.white,
    Function()? onBack,
    Widget? left,
    Widget? center,
    Widget? right,
  }) {
    return AppBar(
      shadowColor: shadowColor,
      elevation: elevation,
      titleSpacing: 0,
      backgroundColor: backgroundColor,
      toolbarHeight: height,
      leading: null,
      automaticallyImplyLeading: false,
      title: Container(
        height: height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: left,
            ),
            Align(
              alignment: Alignment.center,
              child: center,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: right,
            )
          ],
        ),
      ),
    );
  }
}
