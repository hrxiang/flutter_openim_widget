import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef IndexedToolsBuilder = Widget Function(
    BuildContext context, int index, ToolsItem item);

class ChatToolsView extends StatelessWidget {
  final List<ToolsItem>? items;
  final ToolsLayoutParams? layoutParams;
  final Function()? onTapAlbum;
  final Function()? onTapCamera;
  final Function()? onTapVideoCall;
  final Function()? onTapLocation;
  final Function()? onTapFile;
  final Function()? onTapCarte;
  final Function()? onTapVoiceInput;

  const ChatToolsView({
    Key? key,
    this.items,
    this.layoutParams,
    this.onTapAlbum,
    this.onTapCamera,
    this.onTapVideoCall,
    this.onTapLocation,
    this.onTapFile,
    this.onTapCarte,
    this.onTapVoiceInput,
    // this.shrinkWrap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: layoutParams?.crossAxisCount ?? 4,
      mainAxisSpacing: layoutParams?.mainAxisSpacing ?? 0.0,
      crossAxisSpacing: layoutParams?.crossAxisSpacing ?? 0.0,
      childAspectRatio: layoutParams?.childAspectRatio ?? 66 / 48,
      // cacheExtent: layoutParams?.cacheExtent,
      shrinkWrap: layoutParams?.shrinkWrap ?? true,
      padding: layoutParams?.padding ?? EdgeInsets.fromLTRB(0, 13.h, 0, 13.h),
      // children: _toolsItem().map((e) => _toolsOption(e)).toList()
      children: (items ?? _toolsItem(context)).map((e) => _toolsOption(e)).toList(),
    );
  }

  List<ToolsItem> _toolsItem(BuildContext context) => [
        ToolsItem(
          label: UILocalizations.album,
          style: toolsTextSyle,
          image: _buildBtn(
            icon: ChatIcon.toolsAlbum(),
            onTap: onTapAlbum,
            // onTap: () => PermissionUtil.storage(() => onTapAlbum?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.camera,
          style: toolsTextSyle,
          image: _buildBtn(
            icon: ChatIcon.toolsCamera(),
            onTap: onTapCamera,
            // onTap: () => PermissionUtil.camera(() => onTapCamera?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.videoCall,
          style: toolsTextSyle,
          image: _buildBtn(
            icon: ChatIcon.toolsVideoCall(),
            onTap: onTapVideoCall,
            // onTap: () => PermissionUtil.camera(() => onTapVideoCall?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.location,
          style: toolsTextSyle,
          image: _buildBtn(
            icon: ChatIcon.toolsLocation(),
            onTap: onTapLocation,
            // onTap: () => PermissionUtil.location(() => onTapLocation?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.file,
          style: toolsTextSyle,
          image: _buildBtn(
            icon: ChatIcon.toolsFile(),
            onTap: onTapFile,
            // onTap: () => PermissionUtil.storage(() => onTapFile?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.carte,
          style: toolsTextSyle,
          image: _buildBtn(
            icon: ChatIcon.toolsCarte(),
            onTap: onTapCarte,
          ),
        ),
        ToolsItem(
          label: UILocalizations.voiceInput,
          style: toolsTextSyle,
          image: _buildBtn(
            icon: ChatIcon.toolsVoiceInput(),
            onTap: onTapVoiceInput,
            // onTap: () => PermissionUtil.microphone(
            //   () => onTapVoiceInput?.call(),
            // ),
          ),
        ),
      ];

  Widget _buildBtn({required Widget icon, Function()? onTap}) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: icon,
      );

  static var toolsTextSyle = TextStyle(
    fontSize: 11.sp,
    color: Color(0xFF999999),
  );

  Widget _toolsOption(ToolsItem item) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: item.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            item.image,
            SizedBox(
              height: 2.h,
            ),
            Text(
              item.label,
              style: item.style ??
                  TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 11.sp,
                  ),
            )
          ],
        ),
      );
}

class ToolsItem {
  final String label;
  final Widget image;
  final TextStyle? style;
  final Function()? onTap;

  ToolsItem({
    required this.label,
    required this.image,
    this.style,
    this.onTap,
  });
}

class ToolsLayoutParams {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final double? mainAxisExtent;
  final double? cacheExtent;
  final bool? shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const ToolsLayoutParams(
      {required this.crossAxisCount,
      this.mainAxisSpacing = 0.0,
      this.crossAxisSpacing = 0.0,
      this.childAspectRatio = 1.0,
      this.shrinkWrap = true,
      this.mainAxisExtent,
      this.cacheExtent,
      this.padding});
}
