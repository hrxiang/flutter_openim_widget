import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef IndexedToolsBuilder = Widget Function(
    BuildContext context, int index, ToolsItem item);

class ChatToolsView extends StatefulWidget {
  final List<ToolsItem>? items;
  final ToolsLayoutParams? layoutParams;
  final Function()? onTapAlbum;
  final Function()? onTapCamera;
  final Function()? onTapVideoCall;
  final Function()? onTapLocation;
  final Function()? onTapFile;
  final Function()? onTapCarte;
  final Function()? onStartVoiceInput;
  final Function()? onStopVoiceInput;

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
    this.onStartVoiceInput,
    this.onStopVoiceInput,
    // this.shrinkWrap = false,
  }) : super(key: key);

  @override
  _ChatToolsViewState createState() => _ChatToolsViewState();
}

class _ChatToolsViewState extends State<ChatToolsView>
    with TickerProviderStateMixin {
  var _enabledVoiceInput = false;
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

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* return GridView.count(
      crossAxisCount: layoutParams?.crossAxisCount ?? 4,
      mainAxisSpacing: layoutParams?.mainAxisSpacing ?? 0.0,
      crossAxisSpacing: layoutParams?.crossAxisSpacing ?? 0.0,
      childAspectRatio: layoutParams?.childAspectRatio ?? 66 / 48,
      // cacheExtent: layoutParams?.cacheExtent,
      shrinkWrap: layoutParams?.shrinkWrap ?? true,
      padding: layoutParams?.padding ?? EdgeInsets.fromLTRB(0, 13.h, 0, 13.h),
      // children: _toolsItem().map((e) => _toolsOption(e)).toList()
      children:
          (items ?? _toolsItem(context)).map((e) => _toolsOption(e)).toList(),
    );*/
    return Container(
      height: 190.h,
      child: Stack(
        children: [
          FadeInUp(
            duration: Duration(milliseconds: 200),
            child: _buildToolsLayout(),
          ),
          _buildVoiceInputLayout(),
        ],
      ),
    );
  }

  Widget _buildToolsLayout() => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 38.w, vertical: 17.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _toolsOption(ToolsItem(
                  label: UILocalizations.album,
                  style: toolsTextStyle,
                  image: _buildBtn(
                    icon: ImageUtil.toolsAlbum(),
                    onTap: widget.onTapAlbum,
                  ),
                )),
                SizedBox(
                  height: 14.h,
                ),
                _toolsOption(ToolsItem(
                  label: UILocalizations.file,
                  style: toolsTextStyle,
                  image: _buildBtn(
                    icon: ImageUtil.toolsFile(),
                    onTap: widget.onTapFile,
                  ),
                )),
              ],
            ),
            Spacer(),
            Column(
              children: [
                _toolsOption(ToolsItem(
                  label: UILocalizations.camera,
                  style: toolsTextStyle,
                  image: _buildBtn(
                    icon: ImageUtil.toolsCamera(),
                    onTap: widget.onTapCamera,
                  ),
                )),
                SizedBox(
                  height: 14.h,
                ),
                _toolsOption(ToolsItem(
                  label: UILocalizations.carte,
                  style: toolsTextStyle,
                  image: _buildBtn(
                    icon: ImageUtil.toolsCarte(),
                    onTap: widget.onTapCarte,
                  ),
                )),
              ],
            ),
            Spacer(),
            Column(
              children: [
                _toolsOption(ToolsItem(
                  label: UILocalizations.videoCall,
                  style: toolsTextStyle,
                  image: _buildBtn(
                    icon: ImageUtil.toolsVideoCall(),
                    onTap: widget.onTapVideoCall,
                  ),
                )),
                SizedBox(
                  height: 14.h,
                ),
                _toolsOption(ToolsItem(
                  label: UILocalizations.voiceInput,
                  style: toolsTextStyle,
                  image: _buildBtn(
                    icon: ImageUtil.toolsVoiceInput(),
                    onTap: () {
                      setState(() {
                        _enabledVoiceInput = true;
                        _controller.forward();
                      });
                    },
                  ),
                )),
              ],
            ),
            Spacer(),
            _toolsOption(ToolsItem(
              label: UILocalizations.location,
              style: toolsTextStyle,
              image: _buildBtn(
                icon: ImageUtil.toolsLocation(),
                onTap: widget.onTapLocation,
              ),
            )),
          ],
        ),
      );

  Widget _buildVoiceInputLayout() => AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0, 190.h * _animation.value),
          child: Visibility(
            visible: _enabledVoiceInput,
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Center(
                    child: LongPressRippleAnimation(
                      radius: 44.h,
                      child: ImageUtil.voiceInputNor(),
                      onStart: widget.onStartVoiceInput,
                      onStop: widget.onStopVoiceInput,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 30.w),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          // size: 48.w,
                        ),
                        onPressed: () {
                          _controller.reverse();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });

  /*List<ToolsItem> _toolsItem(BuildContext context) => [
        ToolsItem(
          label: UILocalizations.album,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsAlbum(),
            onTap: onTapAlbum,
            // onTap: () => PermissionUtil.storage(() => onTapAlbum?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.camera,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsCamera(),
            onTap: onTapCamera,
            // onTap: () => PermissionUtil.camera(() => onTapCamera?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.videoCall,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsVideoCall(),
            onTap: onTapVideoCall,
            // onTap: () => PermissionUtil.camera(() => onTapVideoCall?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.location,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsLocation(),
            onTap: onTapLocation,
            // onTap: () => PermissionUtil.location(() => onTapLocation?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.file,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsFile(),
            onTap: onTapFile,
            // onTap: () => PermissionUtil.storage(() => onTapFile?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.carte,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsCarte(),
            onTap: onTapCarte,
          ),
        ),
        ToolsItem(
          label: UILocalizations.voiceInput,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsVoiceInput(),
            onTap: onTapVoiceInput,
            // onTap: () => PermissionUtil.microphone(
            //   () => onTapVoiceInput?.call(),
            // ),
          ),
        ),
      ];*/

  Widget _buildBtn({required Widget icon, Function()? onTap}) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: icon,
      );

  static var toolsTextStyle = TextStyle(
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

/*class ChatToolsView extends StatelessWidget {
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
    */ /* return GridView.count(
      crossAxisCount: layoutParams?.crossAxisCount ?? 4,
      mainAxisSpacing: layoutParams?.mainAxisSpacing ?? 0.0,
      crossAxisSpacing: layoutParams?.crossAxisSpacing ?? 0.0,
      childAspectRatio: layoutParams?.childAspectRatio ?? 66 / 48,
      // cacheExtent: layoutParams?.cacheExtent,
      shrinkWrap: layoutParams?.shrinkWrap ?? true,
      padding: layoutParams?.padding ?? EdgeInsets.fromLTRB(0, 13.h, 0, 13.h),
      // children: _toolsItem().map((e) => _toolsOption(e)).toList()
      children:
          (items ?? _toolsItem(context)).map((e) => _toolsOption(e)).toList(),
    );*/ /*
    return Container(
      height: 190.h,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 38.w, vertical: 17.h),
            child: _buildChildren(),
          ),
          SlideInUp(
            child: Container(
              color: Colors.white,
              child: Center(
                child: ImageUtil.voiceInputNor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildren() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _toolsOption(ToolsItem(
                label: UILocalizations.album,
                style: toolsTextStyle,
                image: _buildBtn(
                  icon: ImageUtil.toolsAlbum(),
                  onTap: onTapAlbum,
                ),
              )),
              SizedBox(
                height: 14.h,
              ),
              _toolsOption(ToolsItem(
                label: UILocalizations.file,
                style: toolsTextStyle,
                image: _buildBtn(
                  icon: ImageUtil.toolsFile(),
                  onTap: onTapFile,
                ),
              )),
            ],
          ),
          Spacer(),
          Column(
            children: [
              _toolsOption(ToolsItem(
                label: UILocalizations.camera,
                style: toolsTextStyle,
                image: _buildBtn(
                  icon: ImageUtil.toolsCamera(),
                  onTap: onTapCamera,
                ),
              )),
              SizedBox(
                height: 14.h,
              ),
              _toolsOption(ToolsItem(
                label: UILocalizations.carte,
                style: toolsTextStyle,
                image: _buildBtn(
                  icon: ImageUtil.toolsCarte(),
                  onTap: onTapCarte,
                ),
              )),
            ],
          ),
          Spacer(),
          Column(
            children: [
              _toolsOption(ToolsItem(
                label: UILocalizations.videoCall,
                style: toolsTextStyle,
                image: _buildBtn(
                  icon: ImageUtil.toolsVideoCall(),
                  onTap: onTapVideoCall,
                ),
              )),
              SizedBox(
                height: 14.h,
              ),
              _toolsOption(ToolsItem(
                label: UILocalizations.voiceInput,
                style: toolsTextStyle,
                image: _buildBtn(
                  icon: ImageUtil.toolsVoiceInput(),
                  onTap: onTapVoiceInput,
                ),
              )),
            ],
          ),
          Spacer(),
          _toolsOption(ToolsItem(
            label: UILocalizations.location,
            style: toolsTextStyle,
            image: _buildBtn(
              icon: ImageUtil.toolsLocation(),
              onTap: onTapLocation,
            ),
          )),
        ],
      );

  */ /*List<ToolsItem> _toolsItem(BuildContext context) => [
        ToolsItem(
          label: UILocalizations.album,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsAlbum(),
            onTap: onTapAlbum,
            // onTap: () => PermissionUtil.storage(() => onTapAlbum?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.camera,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsCamera(),
            onTap: onTapCamera,
            // onTap: () => PermissionUtil.camera(() => onTapCamera?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.videoCall,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsVideoCall(),
            onTap: onTapVideoCall,
            // onTap: () => PermissionUtil.camera(() => onTapVideoCall?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.location,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsLocation(),
            onTap: onTapLocation,
            // onTap: () => PermissionUtil.location(() => onTapLocation?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.file,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsFile(),
            onTap: onTapFile,
            // onTap: () => PermissionUtil.storage(() => onTapFile?.call()),
          ),
        ),
        ToolsItem(
          label: UILocalizations.carte,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsCarte(),
            onTap: onTapCarte,
          ),
        ),
        ToolsItem(
          label: UILocalizations.voiceInput,
          style: toolsTextStyle,
          image: _buildBtn(
            icon: ImageUtil.toolsVoiceInput(),
            onTap: onTapVoiceInput,
            // onTap: () => PermissionUtil.microphone(
            //   () => onTapVoiceInput?.call(),
            // ),
          ),
        ),
      ];*/ /*

  Widget _buildBtn({required Widget icon, Function()? onTap}) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: icon,
      );

  static var toolsTextStyle = TextStyle(
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
}*/

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
