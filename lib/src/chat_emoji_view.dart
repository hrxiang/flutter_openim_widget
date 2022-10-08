import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:should_rebuild/should_rebuild.dart';

const emojiFaces = <String, String>{
  '[亲亲]': 'ic_face_01',
  '[看穿]': 'ic_face_02',
  '[色]': 'ic_face_03',
  '[吓哭]': 'ic_face_04',
  '[笑脸]': 'ic_face_05',
  '[眨眼]': 'ic_face_06',
  '[搞怪]': 'ic_face_07',
  '[龇牙]': 'ic_face_08',
  '[无语]': 'ic_face_09',
  '[可怜]': 'ic_face_10',
  '[咒骂]': 'ic_face_11',
  '[晕]': 'ic_face_12',
  '[尴尬]': 'ic_face_13',
  '[暴怒]': 'ic_face_14',
  '[可爱]': 'ic_face_15',
  '[哭泣]': 'ic_face_16',
};

class ChatEmojiView extends StatefulWidget {
  const ChatEmojiView({
    Key? key,
    this.onAddEmoji,
    this.onDeleteEmoji,
    this.favoriteList = const [],
    this.onAddFavorite,
    this.onSelectedFavorite,
    required this.textEditingController,
    this.height,
    this.customEmojiLayout,
  }) : super(key: key);
  final Function()? onDeleteEmoji;
  final Function(String emoji)? onAddEmoji;
  final List<String> favoriteList;
  final Function()? onAddFavorite;
  final Function(int index, String url)? onSelectedFavorite;
  final TextEditingController textEditingController;
  final double? height;
  final Widget? customEmojiLayout;

  @override
  _ChatEmojiViewState createState() => _ChatEmojiViewState();
}

class _ChatEmojiViewState extends State<ChatEmojiView> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 200),
      child: Container(
        // height: 190.h,
        color: Colors.white,
        child: Column(
          children: [
            IndexedStack(
              index: _index,
              children: [
                widget.customEmojiLayout ??
                    ShouldRebuild<EmojiLayout>(
                      shouldRebuild: (oldWidget, newWidget) => false,
                      child: EmojiLayout(
                        controller: widget.textEditingController,
                      ),
                    ),
                _buildFavoriteLayout(),
              ],
            ),
            _buildTabView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() => Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 9.w),
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(
              color: const Color(0xFFEAEAEA),
              width: 1.h,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildTabSelectedBgView(selected: _index == 0, index: 0),
            _buildTabSelectedBgView(selected: _index == 1, index: 1),
            // Spacer(),
            // if (_index == 0) _buildFaceDelBtn(),
          ],
        ),
      );

  Widget _buildFaceDelBtn() => GestureDetector(
        onTap: widget.onDeleteEmoji,
        child: Container(
          // width: 25.w,
          // height: 25.h,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 13.w),
          child: Center(
            child: ImageUtil.assetImage(
              'ic_del_face',
              width: 18.w,
              height: 16.h,
            ),
          ),
        ),
      );

  Widget _buildTabSelectedBgView({
    bool selected = false,
    int index = 0,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            _index = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 13.w),
          decoration: BoxDecoration(
            color: selected ? Color(0xFF000000).withOpacity(0.06) : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ImageUtil.assetImage(
              index == 0
                  ? (selected ? 'ic_face_sel' : 'ic_face_nor')
                  : (selected ? 'ic_favorite_sel' : 'ic_favorite_nor'),
              width: 19,
              height: 19),
        ),
      );

  Widget _buildEmojiLayout() => Container(
        // color: Colors.white,
        height: widget.height ?? 250.h,
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          itemCount: emojiFaces.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            childAspectRatio: 1,
            mainAxisSpacing: 1.w,
            crossAxisSpacing: 10.w,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors.transparent,
              child: Ink(
                child: InkWell(
                  onTap: () =>
                      widget.onAddEmoji?.call(emojiFaces.keys.elementAt(index)),
                  child: Center(
                    child: ImageUtil.assetImage(
                      emojiFaces.values.elementAt(index),
                      width: 30.h,
                      height: 30.h,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildFavoriteLayout() => Container(
        // color: Colors.white,
        height: widget.height ?? 250.h,
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          itemCount: widget.favoriteList.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 20.h,
            crossAxisSpacing: 37.w,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return GestureDetector(
                onTap: widget.onAddFavorite,
                child: Center(
                  child: ImageUtil.assetImage('ic_add_emoji'),
                ),
              );
            }
            var url = widget.favoriteList.elementAt(index - 1);
            return GestureDetector(
              onTap: () => widget.onSelectedFavorite?.call(index - 1, url),
              child: Center(
                child: ImageUtil.lowMemoryNetworkImage(
                  url: url,
                  width: 60.w,
                  cacheWidth: 60.w.toInt(),
                ),
              ),
            );
          },
        ),
      );
}

class EmojiLayout extends StatelessWidget {
  const EmojiLayout({
    Key? key,
    required this.controller,
    this.height,
  }) : super(key: key);
  final TextEditingController controller;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 250.h,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          // Do something when emoji is tapped
          controller
            ..text += emoji.emoji
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
        },
        onBackspacePressed: () {
          // Backspace-Button tapped logic
          // Remove this line to also remove the button in the UI
          controller
            ..text = controller.text.characters.skipLast(1).toString()
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
        },
        config: Config(
          columns: 7,
          emojiSizeMax: 28 * (Platform.isIOS ? 1.30 : 1.0),
          // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: Color(0xFFFFFFFF),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          showRecentsTab: true,
          recentsLimit: 28,
          noRecents: Text(
            UILocalizations.recentlyUsed,
            style: TextStyle(fontSize: 16, color: Colors.black26),
            textAlign: TextAlign.center,
          ),
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );
  }
}
