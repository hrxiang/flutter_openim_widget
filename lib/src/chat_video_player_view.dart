import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

abstract class VideoControllerService {
  Future<VideoPlayerController> getControllerForVideo(String videoUrl);
}

class CachedVideoControllerService extends VideoControllerService {
  final BaseCacheManager _cacheManager;

  CachedVideoControllerService(this._cacheManager);

  @override
  Future<VideoPlayerController> getControllerForVideo(String videoUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(videoUrl);

    if (fileInfo == null) {
      print('[VideoControllerService]: No video in cache');

      print('[VideoControllerService]: Saving video to cache');
      unawaited(_cacheManager.downloadFile(videoUrl));

      return VideoPlayerController.network(videoUrl);
    } else {
      print('[VideoControllerService]: Loading video from cache');
      return VideoPlayerController.file(fileInfo.file);
    }
  }
}

class ChatVideoPlayerView extends StatefulWidget {
  final String? path;
  final String? url;
  final String? coverUrl;
  final String? heroTag;
  final Dio? dio;
  final Function(String url, String path)? onStartDownload;
  final Function(String url, String path)? onDownloadFinished;
  final bool enabledHero;

  const ChatVideoPlayerView({
    Key? key,
    this.path,
    this.url,
    this.coverUrl,
    this.heroTag,
    this.dio,
    this.onDownloadFinished,
    this.onStartDownload,
    this.enabledHero = false,
  }) : super(key: key);

  @override
  _ChatVideoPlayerViewState createState() => _ChatVideoPlayerViewState();
}

class _ChatVideoPlayerViewState extends State<ChatVideoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final _cachedVideoControllerService =
      CachedVideoControllerService(DefaultCacheManager());
  bool _isInitialized = false;

  _startDownload() async {
    var dir = await getTemporaryDirectory();
    var name = widget.url!.substring(widget.url!.lastIndexOf('/'));
    String savePath = dir.path + name;
    widget.onStartDownload?.call(widget.url!, savePath);
    await widget.dio?.download(
      widget.url!,
      savePath,
      options: Options(receiveTimeout: 120 * 1000),
    );
    widget.onDownloadFinished?.call(widget.url!, savePath);
  }

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    File? file;
    bool existFile = false;
    if (null != _path && _path!.isNotEmpty) {
      file = File(_path!);
      existFile = await file.exists();
      if (!existFile) {
        file = null;
      }
    }
    if (null != file) {
      _videoPlayerController = VideoPlayerController.file(file);
    } else {
      // file = await DefaultCacheManager().getSingleFile(_url!).timeout(
      //       Duration(seconds: 60),
      //     );
      // _videoPlayerController = VideoPlayerController.file(file);

      // _videoPlayerController = VideoPlayerController.network(_url!);
      _videoPlayerController =
          await _cachedVideoControllerService.getControllerForVideo(_url!);
    }
    // await Future.wait([
    //   _videoPlayerController.initialize(),
    // ]);
    await _videoPlayerController.initialize();
    _isInitialized = true;
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControlsOnInitialize: true,
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: UILocalizations.playSpeed,
        cancelButtonText: UILocalizations.cancel,
      ),
      additionalOptions: (context) => [
        OptionItem(
          onTap: () {
            Navigator.pop(context);
            _startDownload();
          },
          iconData: Icons.download,
          title: UILocalizations.download,
        ),
      ],
      // showOptions: false,
      // Try playing around with some of these other options:
      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: SizedBox(),
      // autoInitialize: true,
    );
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    var child = Stack(children: [
      _buildChildView(),
      _buildBackBtn(onTap: () => Navigator.pop(context)),
    ]);
    return Material(
      color: Color(0xFF000000),
      child: (widget.enabledHero && widget.heroTag != null)
          ? Hero(tag: widget.heroTag!, child: child)
          : child,
    );
  }

  Widget _buildChildView() => SafeArea(
        child: Stack(
          children: [
            Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : CircularProgressIndicator(),
            ),
          ],
        ),
      );

  Widget _buildCoverView() => Stack(
        alignment: Alignment.center,
        children: [
          if (null != widget.coverUrl)
            ImageUtil.networkImage(
              url: widget.coverUrl!,
              loadProgress: false,
            ),
          CircularProgressIndicator(),
        ],
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

/*
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
                  : _buildCoverView(),
            )
          ],
        ),
      );

  Widget _buildCoverView() => Stack(
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
*/
