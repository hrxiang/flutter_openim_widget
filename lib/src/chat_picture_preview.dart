import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatPicturePreview extends StatelessWidget {
  const ChatPicturePreview({
    Key? key,
    required this.tag,
    this.url,
    this.file,
    this.onDownload,
  }) : super(key: key);
  final String? url;
  final File? file;
  final String tag;
  final Future<bool> Function(String)? onDownload;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF000000),
      child: Stack(
        children: [
          ExtendedImageGesturePageView.builder(
            controller: ExtendedPageController(
              initialPage: 0,
              pageSpacing: 10,
            ),
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              if (null != url && url!.isNotEmpty) {
                return ExtendedImage.network(
                  url!,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                  clearMemoryCacheWhenDispose: true,
                  handleLoadingProgress: true,
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        {
                          final ImageChunkEvent? loadingProgress =
                              state.loadingProgress;
                          final double? progress =
                              loadingProgress?.expectedTotalBytes != null
                                  ? loadingProgress!.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null;
                          return Center(
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                value: progress,
                              ),
                            ),
                          );
                        }
                      case LoadState.completed:
                        {
                          ///if you don't want override completed widget
                          ///please return null or state.completedWidget
                          //return null;
                          //return state.completedWidget;
                          // return ExtendedRawImage(
                          //   image: state.extendedImageInfo?.image,
                          // );
                          return null;
                        }
                      case LoadState.failed:
                        //remove memory cached
                        state.imageProvider.evict();
                        return _errorView();
                    }
                  },
                  initGestureConfigHandler: (ExtendedImageState state) {
                    return GestureConfig(
                      //you must set inPageView true if you want to use ExtendedImageGesturePageView
                      inPageView: true,
                      initialScale: 1.0,
                      maxScale: 5.0,
                      animationMaxScale: 6.0,
                      initialAlignment: InitialAlignment.center,
                    );
                  },
                );
              } else {
                return ExtendedImage.file(
                  file!,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                  clearMemoryCacheWhenDispose: true,
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        {
                          final ImageChunkEvent? loadingProgress =
                              state.loadingProgress;
                          final double? progress =
                              loadingProgress?.expectedTotalBytes != null
                                  ? loadingProgress!.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null;
                          return Center(
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                value: progress,
                              ),
                            ),
                          );
                        }
                      case LoadState.completed:
                        {
                          ///if you don't want override completed widget
                          ///please return null or state.completedWidget
                          //return null;
                          //return state.completedWidget;
                          // return ExtendedRawImage(
                          //   image: state.extendedImageInfo?.image,
                          // );
                          return null;
                        }
                      case LoadState.failed:
                        //remove memory cached
                        state.imageProvider.evict();
                        return _errorView();
                    }
                  },
                  initGestureConfigHandler: (ExtendedImageState state) {
                    return GestureConfig(
                      //you must set inPageView true if you want to use ExtendedImageGesturePageView
                      inPageView: true,
                      initialScale: 1.0,
                      maxScale: 5.0,
                      animationMaxScale: 6.0,
                      initialAlignment: InitialAlignment.center,
                    );
                  },
                );
              }
            },
          ),
          /* null != provider
              ? PhotoView(
                  // onTapDown: (context, details, value) => Navigator.pop(context),
                  imageProvider: provider,
                  // disableGestures: false,
                  // gaplessPlayback: true,
                  // enableRotation: true,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: tag,
                    // placeholderBuilder: (context, heroSize, child) => Center(
                    //   child: CupertinoActivityIndicator(),
                    // ),
                  ),
                  // customSize: Size(200.w, 400.h),
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                  errorBuilder: (context, error, stackTrace) => _errorView(),
                )
              : _errorView(),*/
          Positioned(
            top: 40.h,
            left: 30.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  // color: Color(0xFFFFFFFF).withOpacity(0.23),
                  color: Colors.grey.withOpacity(0.5),
                  // color: Colors.blue,
                  // borderRadius: BorderRadius.circular(16),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
          if (null != url && url!.isNotEmpty)
            Positioned(
              top: 676.h,
              width: 375.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      bool? success = await onDownload?.call(url!);
                    },
                    child: Container(
                      width: 100.w,
                      height: 30.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: Color(0xFFFFFFFF).withOpacity(0.23),
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        UILocalizations.download,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _errorView() => Container(
        width: 375.w,
        color: Color(0xFF999999),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconUtil.error(width: 80.w, height: 70.h),
            SizedBox(
              height: 19.h,
            ),
            Text(
              UILocalizations.picLoadError,
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            )
          ],
        ),
      );
}
