import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FadeInExtendedImage extends StatefulWidget {
  const FadeInExtendedImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
    this.clearMemoryCacheWhenDispose = true,
    this.lowMemory = true,
    this.loadProgress = true,
    this.errorWidget,
  }) : super(key: key);

  final String url;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final bool loadProgress;
  final bool clearMemoryCacheWhenDispose;
  final bool lowMemory;
  final Widget? errorWidget;

  @override
  State<FadeInExtendedImage> createState() => _FadeInExtendedImageState();
}

class _FadeInExtendedImageState extends State<FadeInExtendedImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      cacheWidth:
          widget.lowMemory ? widget.cacheWidth ?? (1.sw * .75).toInt() : null,
      cacheHeight: widget.lowMemory ? widget.cacheHeight : null,
      cache: true,
      clearMemoryCacheWhenDispose: widget.clearMemoryCacheWhenDispose,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            {
              _controller.reset();
              final ImageChunkEvent? loadingProgress = state.loadingProgress;
              final double? progress =
                  loadingProgress?.expectedTotalBytes != null
                      ? loadingProgress!.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null;
              // CupertinoActivityIndicator()
              return Container(
                width: 15.0,
                height: 15.0,
                child: widget.loadProgress
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          value: progress ?? 0,
                        ),
                      )
                    : null,
              );
            }
          case LoadState.completed:
            _controller.forward();

            ///if you don't want override completed widget
            ///please return null or state.completedWidget
            //return null;
            //return state.completedWidget;
            return FadeTransition(
              opacity: _controller,
              child: ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: widget.width,
                height: widget.height,
              ),
            );
          case LoadState.failed:
            _controller.reset();
            // remove memory cached
            state.imageProvider.evict();
            return widget.errorWidget ??
                ImageUtil.error(width: widget.width, height: widget.height);
        }
      },
    );
  }
}
