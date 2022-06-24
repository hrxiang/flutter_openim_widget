import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PicInfo {
  final String? url;
  final File? file;
  final String? id;

  PicInfo({this.url, this.file, this.id});
}
//
// class ChatPicturePreview extends StatelessWidget {
//   ChatPicturePreview({
//     Key? key,
//     required this.picList,
//     this.index = 0,
//     this.tag,
//     this.dio,
//     this.onStartDownload,
//     this.onDownloadFinished,
//     this.background,
//   })  : this.controller = ExtendedPageController(
//           initialPage: index,
//           pageSpacing: 10,
//         ),
//         super(key: key);
//   final List<PicInfo> picList;
//   final int index;
//   final String? tag;
//   final ExtendedPageController controller;
//   final Dio? dio;
//   final Function(String url, String cachePath)? onStartDownload;
//   final Function(String url, String cachePath)? onDownloadFinished;
//   final Color? background;
//
//   void _startDownload(int index) async {
//     var url = picList.elementAt(index).url!;
//     var name = url.substring(url.lastIndexOf('/'));
//     var dir = await getTemporaryDirectory();
//     String savePath = dir.path + name;
//     onStartDownload?.call(url, savePath);
//     await dio?.download(
//       picList.elementAt(index).url!,
//       savePath,
//       options: Options(receiveTimeout: 120 * 1000),
//     );
//     onDownloadFinished?.call(url, savePath);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var child = Stack(
//       children: [
//         _buildPageView(),
//         _buildBackBtn(onTap: () => Navigator.pop(context)),
//         _buildToolsBtn(onDownload: () {
//           int index = controller.page?.toInt() ?? 0;
//           if (index < picList.length) {
//             _startDownload(index);
//             // onDownload?.call(picList.elementAt(index).url!);
//           }
//         }),
//       ],
//     );
//     return Material(
//       color: background ?? Color(0xFF000000),
//       child: tag == null ? child : Hero(tag: tag!, child: child),
//     );
//   }
//
//   Widget _buildChildView(int index) {
//     var info = picList.elementAt(index);
//     if (info.file != null) {
//       return ExtendedImage.file(
//         info.file!,
//         fit: BoxFit.contain,
//         mode: ExtendedImageMode.gesture,
//         clearMemoryCacheWhenDispose: true,
//         loadStateChanged: _buildLoadStateChangedView,
//         initGestureConfigHandler: _buildGestureConfig,
//       );
//     } else if (info.url != null) {
//       return ExtendedImage.network(
//         info.url!,
//         fit: BoxFit.contain,
//         mode: ExtendedImageMode.gesture,
//         clearMemoryCacheWhenDispose: true,
//         handleLoadingProgress: true,
//         loadStateChanged: _buildLoadStateChangedView,
//         initGestureConfigHandler: _buildGestureConfig,
//       );
//     } else {
//       return _buildErrorView();
//     }
//   }
//
//   GestureConfig _buildGestureConfig(ExtendedImageState state) => GestureConfig(
//         //you must set inPageView true if you want to use ExtendedImageGesturePageView
//         inPageView: true,
//         initialScale: 1.0,
//         maxScale: 5.0,
//         animationMaxScale: 6.0,
//         initialAlignment: InitialAlignment.center,
//       );
//
//   Widget? _buildLoadStateChangedView(ExtendedImageState state) {
//     switch (state.extendedImageLoadState) {
//       case LoadState.loading:
//         {
//           final ImageChunkEvent? loadingProgress = state.loadingProgress;
//           final double? progress = loadingProgress?.expectedTotalBytes != null
//               ? loadingProgress!.cumulativeBytesLoaded /
//                   loadingProgress.expectedTotalBytes!
//               : null;
//           return Center(
//             child: Container(
//               width: 20.0,
//               height: 20.0,
//               child: CircularProgressIndicator(
//                 value: progress,
//               ),
//             ),
//           );
//         }
//       case LoadState.completed:
//         {
//           ///if you don't want override completed widget
//           ///please return null or state.completedWidget
//           return null;
//         }
//       case LoadState.failed:
//         //remove memory cached
//         state.imageProvider.evict();
//         return _buildErrorView();
//     }
//   }
//
//   Widget _buildPageView() => ExtendedImageGesturePageView.builder(
//         controller: controller,
//         itemCount: picList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return _buildChildView(index);
//         },
//       );
//
//   Widget _buildToolsBtn({Function()? onDownload}) => Positioned(
//         top: 676.h,
//         width: 375.w,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               onTap: onDownload,
//               child: Container(
//                 width: 100.w,
//                 height: 30.h,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   // color: Color(0xFFFFFFFF).withOpacity(0.23),
//                   color: Colors.grey.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Text(
//                   UILocalizations.download,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//
//   Widget _buildBackBtn({Function()? onTap}) => Positioned(
//         top: 35.h,
//         left: 30.w,
//         child: GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: onTap,
//           child: Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: Colors.black87.withOpacity(0.4),
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(Icons.close, color: Colors.white),
//           ),
//         ),
//       );
//
//   Widget _buildErrorView() => Container(
//         width: 375.w,
//         color: Color(0xFF999999),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ImageUtil.error(width: 80.w, height: 70.h),
//             SizedBox(
//               height: 19.h,
//             ),
//             Text(
//               UILocalizations.picLoadError,
//               style: TextStyle(color: Colors.white, fontSize: 18.sp),
//             )
//           ],
//         ),
//       );
// }

class ChatPicturePreview extends StatelessWidget {
  ChatPicturePreview({
    Key? key,
    required this.picList,
    this.index = 0,
    this.heroTag,
    // this.onDownload,
    this.dio,
    this.onStartDownload,
    this.onDownloadFinished,
    this.background,
    this.enabledHero = false,
  })  : this.controller = PageController(initialPage: index),
        super(key: key);
  final List<PicInfo> picList;
  final int index;
  final String? heroTag;
  final PageController controller;

  // final Future<bool> Function(String)? onDownload;
  final Dio? dio;
  final Function(String url, String cachePath)? onStartDownload;
  final Function(String url, String cachePath)? onDownloadFinished;
  final Color? background;
  final bool enabledHero;

  void _startDownload(int index) async {
    var url = picList.elementAt(index).url!;
    var name = url.substring(url.lastIndexOf('/'));
    var dir = await getTemporaryDirectory();
    String savePath = dir.path + name;
    onStartDownload?.call(url, savePath);
    await dio?.download(
      picList.elementAt(index).url!,
      savePath,
      options: Options(receiveTimeout: 120 * 1000),
    );
    onDownloadFinished?.call(url, savePath);
  }

  @override
  Widget build(BuildContext context) {
    var child = Stack(
      children: [
        _buildPageView(),
        _buildBackBtn(onTap: () => Navigator.pop(context)),
        _buildToolsBtn(onDownload: () {
          int index = controller.page?.toInt() ?? 0;
          if (index < picList.length) {
            _startDownload(index);
            // onDownload?.call(picList.elementAt(index).url!);
          }
        }),
      ],
    );
    return Material(
      color: Color(0xFF000000),
      child: enabledHero && heroTag != null
          ? Hero(tag: heroTag!, child: child)
          : child,
    );
  }

  ImageProvider? _provider(int index) {
    var info = picList.elementAt(index);
    if (info.file != null) {
      // return ExtendedFileImageProvider(info.file!);
      return FileImage(info.file!);
    } else if (info.url != null) {
      return CachedNetworkImageProvider(info.url!);
    }
    return null;
  }

  PhotoViewHeroAttributes? _heroTag(int index) {
    var hero = picList.elementAt(index).id ?? heroTag;
    if (hero != null) {
      return PhotoViewHeroAttributes(tag: hero);
    }
    return null;
  }

  Widget _buildPageView() => Container(
        // child: PageView.builder(
        //   controller: controller,
        //   itemCount: picList.length,
        //   onPageChanged: onPageChanged,
        //   itemBuilder: (_, index) {
        //     return PhotoView(imageProvider: _provider(index)!);
        //   },
        // ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            // return  Image(image:_provider(index)!);
            return PhotoViewGalleryPageOptions(
              imageProvider: _provider(index),
              initialScale: PhotoViewComputedScale.contained /** 0.8*/,
              // heroAttributes: _heroTag(index),
              errorBuilder: (context, error, stackTrace) => _buildErrorView(),
            );
          },
          itemCount: picList.length,
          loadingBuilder: (context, event) {
            return Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: (event == null || null == event.expectedTotalBytes)
                      ? null
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            );
          },
          // backgroundDecoration: widget.backgroundDecoration,
          pageController: controller,
          onPageChanged: onPageChanged,
        ),
      );

  void onPageChanged(int index) {}

  Widget _buildToolsBtn({Function()? onDownload}) => Positioned(
        top: 676.h,
        width: 375.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onDownload,
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
      );

  Widget _buildBackBtn({Function()? onTap}) => Positioned(
        top: 35.h,
        left: 30.w,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Container(
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

  Widget _buildErrorView() => Container(
        width: 375.w,
        // color: Color(0xFF999999),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageUtil.error(width: 80.w, height: 70.h),
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
