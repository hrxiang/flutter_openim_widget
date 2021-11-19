import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatIcon {
  static String imageResStr(var name) => "assets/images/$name.webp";

  static Widget assetImage(
    String res, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      imageResStr(res),
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  static Widget back({Color color = const Color(0xFF333333)}) => assetImage(
        'ic_back',
        width: 12.w,
        height: 20.h,
        color: color,
      );

  static Widget add() => assetImage(
        "ic_add",
        width: 24.h,
        height: 24.h,
        color: Color(0xFF333333),
      );

  static Widget search() => assetImage(
        'ic_search',
        width: 24.h,
        height: 24.h,
        color: Color(0xFF333333),
      );

  static Widget play() => assetImage(
        'ic_video_play',
        width: 48.h,
        height: 48.h,
      );

  static Widget sendFailed() => assetImage(
        'ic_send_failed',
        width: 16.h,
        height: 16.h,
      );

  static Widget speak() => assetImage(
        'ic_speak',
        width: 26.h,
        height: 26.h,
      );

  static Widget tools() => assetImage(
        'ic_tools',
        width: 26.h,
        height: 26.h,
      );

  static Widget keyboard() => assetImage(
        'ic_keyboard',
        width: 26.h,
        height: 26.h,
      );

  static Widget toolsAlbum() => assetImage(
        'ic_tools_album',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsCamera() => assetImage(
        'ic_tools_camera',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsCarte() => assetImage(
        'ic_tools_carte',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsFile() => assetImage(
        'ic_tools_file',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsLocation() => assetImage(
        'ic_tools_location',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsVideoCall() => assetImage(
        'ic_tools_video_call',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsVoiceInput() => assetImage(
        'ic_tools_voice_input',
        width: 48.h,
        height: 48.h,
      );

  static Widget menuCopy() => assetImage(
        'ic_menu_copy',
        width: 18.w,
        height: 18.h,
      );

  static Widget menuDel() => assetImage(
        'ic_menu_del',
        width: 18.w,
        height: 18.h,
      );

  static Widget menuForward() => assetImage(
        'ic_menu_forward',
        width: 18.w,
        height: 18.h,
      );

  static Widget menuMultiChoice() => assetImage(
        'ic_menu_multichoice',
        width: 18.w,
        height: 18.h,
      );

  static Widget menuReply() => assetImage(
        'ic_menu_reply',
        width: 18.w,
        height: 18.h,
      );

  static Widget menuRevoke() => assetImage(
        'ic_menu_revoke',
        width: 18.w,
        height: 18.h,
      );

  static Widget menuDownload() => assetImage(
        'ic_menu_download',
        width: 18.w,
        height: 18.h,
      );

  static Widget menuTranslation() => assetImage(
        'ic_menu_translation',
        width: 18.w,
        height: 18.h,
      );

  static Widget file() => assetImage(
        'ic_file',
        width: 22.w,
        height: 28.h,
      );

  static Widget delQuote() => assetImage(
        'ic_del_quote',
        width: 14.w,
        height: 15.h,
      );

  static Widget voiceInputNor() => assetImage(
        'ic_voice_input_nor',
        width: 88.h,
        height: 88.h,
        fit: BoxFit.cover,
      );

  static Widget error({
    double? width,
    double? height,
  }) =>
      assetImage(
        'ic_load_error',
        height: height,
        width: width,
      );
}
