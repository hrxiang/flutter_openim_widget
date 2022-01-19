import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PicInfo {
  final String? url;
  final File? file;

  PicInfo({this.url, this.file});
}

class ChatPicturePreview extends StatelessWidget {
  ChatPicturePreview({
    Key? key,
    required this.picList,
    this.index = 0,
    this.tag,
    this.onDownload,
  })  : this.controller = ExtendedPageController(
          initialPage: index,
          pageSpacing: 10,
        ),
        super(key: key);
  final List<PicInfo> picList;
  final int index;
  final String? tag;
  final ExtendedPageController controller;
  final Future<bool> Function(String)? onDownload;

  @override
  Widget build(BuildContext context) {
    var child = Stack(
      children: [
        _buildPageView(),
        _buildBackBtn(onTap: () => Navigator.pop(context)),
        _buildToolsBtn(onDownload: () {
          int index = controller.page?.toInt() ?? 0;
          if (index < picList.length) {
            onDownload?.call(picList.elementAt(index).url!);
          }
        }),
      ],
    );
    return Material(
      color: Color(0xFF000000),
      child: tag == null ? child : Hero(tag: tag!, child: child),
    );
  }

  Widget _buildChildView(int index) {
    var info = picList.elementAt(index);
    if (info.file != null) {
      return ExtendedImage.file(
        info.file!,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: true,
        loadStateChanged: _buildLoadStateChangedView,
        initGestureConfigHandler: _buildGestureConfig,
      );
    } else if (info.url != null) {
      return ExtendedImage.network(
        info.url!,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: true,
        handleLoadingProgress: true,
        loadStateChanged: _buildLoadStateChangedView,
        initGestureConfigHandler: _buildGestureConfig,
      );
    } else {
      return _buildErrorView();
    }
  }

  GestureConfig _buildGestureConfig(ExtendedImageState state) => GestureConfig(
        //you must set inPageView true if you want to use ExtendedImageGesturePageView
        inPageView: true,
        initialScale: 1.0,
        maxScale: 5.0,
        animationMaxScale: 6.0,
        initialAlignment: InitialAlignment.center,
      );

  Widget? _buildLoadStateChangedView(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        {
          final ImageChunkEvent? loadingProgress = state.loadingProgress;
          final double? progress = loadingProgress?.expectedTotalBytes != null
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
        return _buildErrorView();
    }
  }

  Widget _buildPageView() => ExtendedImageGesturePageView.builder(
        controller: controller,
        itemCount: picList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildChildView(index);
        },
      );

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
        top: 40.h,
        left: 30.w,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
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
      );

  Widget _buildErrorView() => Container(
        width: 375.w,
        color: Color(0xFF999999),
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
