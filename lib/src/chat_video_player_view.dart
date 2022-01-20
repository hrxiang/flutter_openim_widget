import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatVideoPlayerView extends StatefulWidget {
  final String? path;
  final String? url;
  final String? coverUrl;
  final String? tag;
  final Function(String url)? onDownload;

  const ChatVideoPlayerView(
      {Key? key, this.path, this.url, this.coverUrl, this.tag, this.onDownload})
      : super(key: key);

  @override
  _ChatVideoPlayerViewState createState() => _ChatVideoPlayerViewState();
}

class _ChatVideoPlayerViewState extends State<ChatVideoPlayerView> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  bool _isInitialized = false;
  double _aspectRatio = 16 / 9;

  @override
  void initState() {
    _initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // _betterPlayerController.dispose();
    super.dispose();
  }

  void _initPlayer() {
    File? file;
    bool existFile = false;
    if (null != _path && _path!.isNotEmpty) {
      file = File(_path!);
      existFile = file.existsSync();
      if (!existFile) {
        file = null;
      }
    }

    var betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: _aspectRatio,
      fit: BoxFit.contain,
      autoPlay: true,
      // looping: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ],
      // placeholder: _buildVideoPlaceholder(),
      controlsConfiguration: BetterPlayerControlsConfiguration(
        playerTheme: BetterPlayerTheme.cupertino,
        enableFullscreen: false,
        enableOverflowMenu: false,
        enablePip: true,
      ),
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
      existFile
          ? BetterPlayerDataSourceType.file
          : BetterPlayerDataSourceType.network,
      existFile ? _path! : _url!,
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
      ),
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        _isInitialized = true;
        _aspectRatio =
            _betterPlayerController.videoPlayerController?.value.aspectRatio ??
                _aspectRatio;
        _betterPlayerController.setOverriddenAspectRatio(_aspectRatio);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var child = Stack(children: [
      _buildChildView(),
      _buildBackBtn(onTap: () => Navigator.pop(context)),
    ]);
    return Material(
      color: Color(0xFF000000),
      child: widget.tag == null ? child : Hero(tag: widget.tag!, child: child),
    );
  }

  Widget _buildChildView() => SafeArea(
        child: Stack(
          children: [
            Center(
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _aspectRatio,
                      child: BetterPlayer(controller: _betterPlayerController),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        if (null != widget.coverUrl)
                          ImageUtil.networkImage(
                            url: widget.coverUrl!,
                            clearMemoryCacheWhenDispose: true,
                            loadProgress: false,
                            cacheWidth: (1.sw).toInt(),
                          ),
                        CircularProgressIndicator(),
                      ],
                    ),
            )
          ],
        ),
      );

  Widget _buildBackBtn({Function()? onTap}) => Positioned(
        top: 35.h,
        left: 30.w,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Container(
            // padding: EdgeInsets.all(6),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.4),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.close, color: Colors.white),
          ),
        ),
      );

  String? get _path => widget.path;

  String? get _url => widget.url;
}
