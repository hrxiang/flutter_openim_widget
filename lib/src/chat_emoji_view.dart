import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class ChatEmojiView extends StatelessWidget {
  const ChatEmojiView({
    Key? key,
    this.onAddEmoji,
    this.onDeleteEmoji,
  }) : super(key: key);
  final Function()? onDeleteEmoji;
  final Function(String emoji)? onAddEmoji;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 200),
      child: Container(
        height: 190.h,
        child: Stack(
          children: [
            _buildEmojiLayout(),
            Positioned(
              bottom: 20.h,
              right: 10.w,
              child: Material(
                child: Ink(
                  child: InkWell(
                    onTap: onDeleteEmoji,
                    child: Container(
                      width: 25.w,
                      height: 25.h,
                      // color: Colors.black45.withOpacity(0.4),
                      child: Center(
                        child: ImageUtil.assetImage(
                          'ic_del_face',
                          width: 18.w,
                          height: 16.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiLayout() => Container(
        color: Colors.white,
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
              child: Ink(
                child: InkWell(
                  onTap: () =>
                      onAddEmoji?.call(emojiFaces.keys.elementAt(index)),
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
}
