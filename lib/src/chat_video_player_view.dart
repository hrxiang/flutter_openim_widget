import 'dart:io';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final FijkPlayer player = FijkPlayer();

  @override
  void initState() {
    // init();
    bool _existPath = false;
    if (null != _path && _path!.isNotEmpty) {
      var file = File(_path!);
      if (file.existsSync()) {
        _existPath = true;
      }
    }
    player.setDataSource(_existPath ? _path! : _url!, autoPlay: true);
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: FijkView(
                player: player,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? get _path => widget.path;

  String? get _url => widget.url;
}
