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

  final Widget Function(BuildContext context, int index, T data) itemBuilder;

  /// 信息消息列表
  final List<T> topList;

  /// 历史消息列表
  final List<T> bottomList;

  ///
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

  /// 还存在历史消息未加载
  var _scrollDownHasMore = true;

  /// 还存在新消息未加载
  var _scrollUpHasMore = true;

  @override
  void initState() {
    _onScrollDownLoadMore();
    widget.controller?.addListener(() {
      if (_isBottom && _scrollDownHasMore) {
        print('-------------ChatListView scroll to bottom');
        _onScrollDownLoadMore();
      } else if (_isTop && widget.enabledScrollUpLoad && _scrollUpHasMore) {
        _onScrollUpLoadMore();
        print('-------------ChatListView scroll to top');
      }
    });
    super.initState();
  }

  bool get _isBottom =>
      widget.controller!.offset == widget.controller!.position.maxScrollExtent;

  bool get _isTop =>
      widget.controller!.offset == widget.controller!.position.minScrollExtent;

  void _onScrollDownLoadMore() {
    widget.onScrollDownLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _scrollDownHasMore = hasMore;
      });
    });
  }

  void _onScrollUpLoadMore() {
    widget.onScrollUpLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _scrollUpHasMore = hasMore;
      });
    });
  }

  Widget _buildLoadMoreView() => Container(
        alignment: Alignment.center,
        height: 60.h,
        child: CupertinoActivityIndicator(
          color: Colors.blueAccent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      center: centerKey,
      controller: widget.controller,
      reverse: true,
      shrinkWrap: false,
      slivers: <Widget>[
        // 底部向上滚动
        if (_scrollUpHasMore && widget.enabledScrollUpLoad)
          SliverToBoxAdapter(child: _buildLoadMoreView()),
        // bottom 加载历史消息
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (_, index) => widget.itemBuilder(
              context,
              index,
              widget.topList.elementAt(index),
            ),
            childCount: widget.topList.length,
          ),
        ),
        // top 加载新消息
        SliverList(
          key: centerKey,
          delegate: SliverChildBuilderDelegate(
                (_, index) => widget.itemBuilder(
              context,
              index,
              widget.bottomList.elementAt(index),
            ),
            childCount: widget.bottomList.length,
          ),
        ),
        // 顶部向下滚动
        if (_scrollDownHasMore)
          SliverToBoxAdapter(child: _buildLoadMoreView()),
      ],
    );
  }
}
