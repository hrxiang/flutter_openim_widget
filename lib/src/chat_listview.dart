import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomChatListView<T> extends StatefulWidget {
  const CustomChatListView({
    Key? key,
    required this.itemBuilder,
    this.topList = const [],
    this.bottomList = const [],
    this.controller,
    this.onScrollDownLoad,
    this.onScrollUpLoad,
    this.enabledScrollUpLoad = false,
  }) : super(key: key);

  final Widget Function(
      BuildContext context, int index, T data, bool isTopListItem) itemBuilder;
  final List<T> topList;
  final List<T> bottomList;
  final ScrollController? controller;

  /// 往下滚动加载，拉取历史消息
  final Future<bool> Function()? onScrollDownLoad;

  /// 往上滚动加载，在搜索消息是定位消息时用到
  final Future<bool> Function()? onScrollUpLoad;

  /// 是否开启往上滚动加载，在搜索消息是定位消息时用到
  final bool enabledScrollUpLoad;

  @override
  State<CustomChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<CustomChatListView> {
  final Key centerKey = ValueKey('second-sliver-list');
  var _scrollDownLoadMore = true;
  var _scrollUpLoadMore = true;

  @override
  void initState() {
    _onScrollDownLoadMore();
    widget.controller?.addListener(() {
      if (_isBottom) {
        print('-------------ChatListView scroll to bottom');
        _onScrollDownLoadMore();
      } else if (_isTop && widget.enabledScrollUpLoad) {
        _onScrollUpLoadMore();
        print('-------------ChatListView scroll to top');
      }
    });
    super.initState();
  }

  bool get _isBottom =>
      widget.controller!.offset >= widget.controller!.position.maxScrollExtent;

  bool get _isTop => widget.controller!.offset <= 0;

  void _onScrollDownLoadMore() {
    widget.onScrollDownLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _scrollDownLoadMore = hasMore;
      });
    });
  }

  void _onScrollUpLoadMore() {
    widget.onScrollUpLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _scrollUpLoadMore = hasMore;
      });
    });
  }

  Widget _buildLoadMoreView() => Container(
        height: 20.h,
        child: CupertinoActivityIndicator(
          color: Colors.blueAccent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    print('----------------topList:${widget.topList.length}');
    print('----------------bottomList:${widget.bottomList.length}');
    return CustomScrollView(
      center: centerKey,
      controller: widget.controller,
      reverse: true,
      // shrinkWrap: true,
      slivers: <Widget>[
        if (_scrollDownLoadMore)
          SliverToBoxAdapter(
            child: _buildLoadMoreView(),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => widget.itemBuilder(
              context,
              index,
              widget.topList.elementAt(index),
              true,
            ),
            childCount: widget.topList.length,
          ),
        ),
        SliverList(
          key: centerKey,
          delegate: SliverChildBuilderDelegate(
            (_, index) => widget.itemBuilder(
              context,
              index,
              widget.bottomList.elementAt(index),
              true,
            ),
            childCount: widget.bottomList.length,
          ),
        ),
        if (_scrollUpLoadMore && widget.enabledScrollUpLoad)
          SliverToBoxAdapter(
            child: _buildLoadMoreView(),
          ),
      ],
    );
  }
}
