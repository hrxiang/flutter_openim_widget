import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'custom_chawie_controls.dart';

class ChatVideoPlayerView extends StatefulWidget {
  final String? path;
  final String? url;
  final Function(String url)? onDownload;

  const ChatVideoPlayerView({Key? key, this.path, this.url, this.onDownload})
      : super(key: key);

  @override
  _ChatVideoPlayerViewState createState() => _ChatVideoPlayerViewState();
}

class _ChatVideoPlayerViewState extends State<ChatVideoPlayerView> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    if (null != _path && _path!.isNotEmpty) {
      var file = File(_path!);
      if (file.existsSync()) {
        videoPlayerController = VideoPlayerController.file(file);
      }
    }
    if (null == videoPlayerController) {
      if (null != _url && _url!.isNotEmpty) {
        videoPlayerController = VideoPlayerController.network(_url!);
      }
    }

    if (null != videoPlayerController) {
      await videoPlayerController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        customControls: CustomCupertinoControls(
          backgroundColor: Color(0xFF5B5B5B),
          iconColor: Colors.white,
          onDownload: () {
            if (null != _url) {
              widget.onDownload?.call(_url!);
            }
          },
        ),
      );

      // chewieController?.addListener(() {});
      setState(() {});
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // backgroundColor: Colors.transparent,
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            if (null == chewieController)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (null != chewieController) Chewie(controller: chewieController!),
          ],
        ),
      ),
    );
  }

  String? get _path => widget.path;

  String? get _url => widget.url;
}
