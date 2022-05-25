import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

// class ChatVoiceView extends StatefulWidget {
//   final int index;
//   final Stream<int>? clickStream;
//   final bool isReceived;
//   final String? soundPath;
//   final String? soundUrl;
//   final int? duration;
//
//   const ChatVoiceView({
//     Key? key,
//     required this.index,
//     required this.clickStream,
//     required this.isReceived,
//     this.soundPath,
//     this.soundUrl,
//     this.duration,
//   }) : super(key: key);
//
//   @override
//   _ChatVoiceViewState createState() => _ChatVoiceViewState();
// }
//
// class _ChatVoiceViewState extends State<ChatVoiceView> {
//   bool _isPlaying = false;
//   bool _isExistSource = false;
//   var _voicePlayer = AudioPlayer();
//   StreamSubscription? _clickSubs;
//
//   @override
//   void initState() {
//     _voicePlayer.playerStateStream.listen((state) {
//       if (!mounted) return;
//       switch (state.processingState) {
//         case ProcessingState.idle:
//         case ProcessingState.loading:
//         case ProcessingState.buffering:
//         case ProcessingState.ready:
//           break;
//         case ProcessingState.completed:
//           setState(() {
//             if (_isPlaying) {
//               _isPlaying = false;
//               // _voicePlayer.stop();
//             }
//           });
//           break;
//       }
//     });
//     _initSource();
//     _clickSubs = widget.clickStream?.listen((i) {
//       if (!mounted) return;
//       print('click:$i    $_isExistSource');
//       if (_isExistSource) {
//         print('sound click:$i');
//         if (_isClickedLocation(i)) {
//           setState(() {
//             if (_isPlaying) {
//               print('sound stop:$i');
//               _isPlaying = false;
//               _voicePlayer.stop();
//             } else {
//               print('sound start:$i');
//               _isPlaying = true;
//               _voicePlayer.seek(Duration.zero);
//               _voicePlayer.play();
//             }
//           });
//         } else {
//           if (_isPlaying) {
//             setState(() {
//               print('sound stop:$i');
//               _isPlaying = false;
//               _voicePlayer.stop();
//             });
//           }
//         }
//       }
//     });
//     super.initState();
//   }
//
//   void _initSource() async {
//     String? path = widget.soundPath;
//     String? url = widget.soundUrl;
//     if (widget.isReceived) {
//       if (null != url && url.trim().isNotEmpty) {
//         _isExistSource = true;
//         _voicePlayer.setUrl(url);
//       }
//     } else {
//       var _existFile = false;
//       if (path != null && path.trim().isNotEmpty) {
//         var file = File(path);
//         _existFile = await file.exists();
//       }
//       if (_existFile) {
//         _isExistSource = true;
//         _voicePlayer.setFilePath(path!);
//       } else if (null != url && url.trim().isNotEmpty) {
//         _isExistSource = true;
//         _voicePlayer.setUrl(url);
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _voicePlayer.dispose();
//     _clickSubs?.cancel();
//     super.dispose();
//   }
//
//   bool _isClickedLocation(i) => i == widget.index;
//
//   Widget _buildVoiceAnimView() {
//     var anim;
//     var png;
//     var turns;
//     if (widget.isReceived) {
//       anim = 'assets/anim/voice_black.json';
//       png = 'assets/images/ic_voice_black.webp';
//       turns = 0;
//     } else {
//       anim = 'assets/anim/voice_blue.json';
//       png = 'assets/images/ic_voice_blue.webp';
//       turns = 90;
//     }
//     return Row(
//       children: [
//         Visibility(
//           visible: !widget.isReceived,
//           child: Text(
//             '${widget.duration ?? 0}``',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Color(0xFF333333),
//             ),
//           ),
//         ),
//         _isPlaying
//             ? RotatedBox(
//                 quarterTurns: turns,
//                 child: Lottie.asset(
//                   anim,
//                   height: 19.h,
//                   width: 18.w,
//                   package: 'flutter_openim_widget',
//                 ),
//               )
//             : Image.asset(
//                 png,
//                 height: 19.h,
//                 width: 18.w,
//                 package: 'flutter_openim_widget',
//               ),
//         Visibility(
//           visible: widget.isReceived,
//           child: Text(
//             '${widget.duration ?? 0}``',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Color(0xFF333333),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//         left: widget.isReceived ? 0 : _margin,
//         right: widget.isReceived ? _margin : 0,
//       ),
//       child: _buildVoiceAnimView(),
//     );
//   }
//
//   double get _margin {
//     double diff = ((widget.duration ?? 0) / 5) * 6.w;
//     return diff > 60.w ? 60.w : diff;
//   }
// }

/// 去掉语音播放功能
class ChatVoiceView extends StatefulWidget {
  final int index;
  final Stream<int>? clickStream;
  final bool isReceived;
  final String? soundPath;
  final String? soundUrl;
  final int? duration;
  final bool isPlaying;

  const ChatVoiceView({
    Key? key,
    required this.index,
    required this.clickStream,
    required this.isReceived,
    this.soundPath,
    this.soundUrl,
    this.duration,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  _ChatVoiceViewState createState() => _ChatVoiceViewState();
}

class _ChatVoiceViewState extends State<ChatVoiceView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildVoiceAnimView() {
    var anim;
    var png;
    var turns;
    if (widget.isReceived) {
      anim = 'assets/anim/voice_black.json';
      png = 'assets/images/ic_voice_black.webp';
      turns = 0;
    } else {
      anim = 'assets/anim/voice_blue.json';
      png = 'assets/images/ic_voice_blue.webp';
      turns = 90;
    }
    return Row(
      children: [
        Visibility(
          visible: !widget.isReceived,
          child: Text(
            '${widget.duration ?? 0}``',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF333333),
            ),
          ),
        ),
        widget.isPlaying
            ? RotatedBox(
                quarterTurns: turns,
                child: Lottie.asset(
                  anim,
                  height: 19.h,
                  width: 18.w,
                  package: 'flutter_openim_widget',
                ),
              )
            : Image.asset(
                png,
                height: 19.h,
                width: 18.w,
                package: 'flutter_openim_widget',
              ),
        Visibility(
          visible: widget.isReceived,
          child: Text(
            '${widget.duration ?? 0}``',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: widget.isReceived ? 0 : _margin,
        right: widget.isReceived ? _margin : 0,
      ),
      child: _buildVoiceAnimView(),
    );
  }

  double get _margin {
    double diff = ((widget.duration ?? 0) / 5) * 6.w;
    return diff > 60.w ? 60.w : diff;
  }
}
