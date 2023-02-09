import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

extension ScrollControllerExt on ScrollController {
  /// 滚动到底部
  Future scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      while (position.pixels != position.maxScrollExtent) {
        jumpTo(position.maxScrollExtent);
        await SchedulerBinding.instance.endOfFrame;
      }
    });
  }

  /// 滚动到顶部
  Future scrollToTop() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      while (position.pixels != position.minScrollExtent) {
        jumpTo(position.minScrollExtent);
        await SchedulerBinding.instance.endOfFrame;
      }
    });
  }
}

class CustomChatListView<T> extends StatefulWidget {
  const CustomChatListView({
    Key? key,
    required this.itemBuilder,
    this.topList = const [],
    this.bottomList = const [],
    this.controller,
    this.onScrollToTopLoad,
    this.onScrollToBottomLoad,
    this.enabledBottomLoad = false,
    this.enabledTopLoad = false,
    this.indicatorColor,
  }) : super(key: key);

  /// index: topList/bottomList的下标
  /// position: 整个列表的下标
  final Widget Function(BuildContext context, int index, int position, T data)
      itemBuilder;

  /// 添加数据 insert(0,T) 或 insertAll(0,<T>[])
  /// UI上index:length-1 -> 0
  final List<T> topList;

  /// 添加数据 add(T) 或 addAll(<T>[])
  /// UI上index:0->length-1
  final List<T> bottomList;

  ///
  final ScrollController? controller;

  /// 滚动到顶部加载，返回ture：还存在未加载完的数据。false：已经没有更多的数据了
  final Future<bool> Function()? onScrollToTopLoad;

  /// 滚动到底部加载，返回ture：还存在未加载完的数据。false：已经没有更多的数据了
  final Future<bool> Function()? onScrollToBottomLoad;

  /// 启用顶部加载
  final bool enabledTopLoad;

  /// 启动底部加载
  final bool enabledBottomLoad;

  final Color? indicatorColor;

  @override
  State<CustomChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<CustomChatListView> {
  final Key centerKey = ValueKey('second-sliver-list');

  var _bottomHasMore = true;

  var _topHasMore = true;

  @override
  void initState() {
    widget.controller?.addListener(() {
      if (widget.enabledBottomLoad && _isBottom && _bottomHasMore) {
        log('-------------ChatListView scroll to bottom');
        _onScrollToBottomLoadMore();
      } else if (widget.enabledTopLoad && _isTop && _topHasMore) {
        _onScrollToTopLoadMore();
        log('-------------ChatListView scroll to top');
      }
    });
    super.initState();
  }

  bool get _isBottom =>
      widget.controller!.offset == widget.controller!.position.maxScrollExtent;

  bool get _isTop =>
      widget.controller!.offset == widget.controller!.position.minScrollExtent;

  void _onScrollToBottomLoadMore() {
    widget.onScrollToBottomLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _bottomHasMore = hasMore;
      });
    });
  }

  void _onScrollToTopLoadMore() {
    widget.onScrollToTopLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _topHasMore = hasMore;
      });
    });
  }

  Widget _buildLoadMoreView() => Container(
        alignment: Alignment.center,
        height: 44,
        child: CupertinoActivityIndicator(
          color: widget.indicatorColor ?? Colors.blueAccent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      center: centerKey,
      controller: widget.controller,
      physics: const AlwaysScrollableScrollPhysics(),
      // reverse: true,
      // shrinkWrap: false,
      slivers: <Widget>[
        if (_topHasMore && widget.enabledTopLoad)
          SliverToBoxAdapter(child: _buildLoadMoreView()),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return widget.itemBuilder(
                context,
                index,
                widget.topList.length - index - 1,
                widget.topList.elementAt(index),
              );
            },
            childCount: widget.topList.length,
          ),
        ),
        SliverList(
          key: centerKey,
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return widget.itemBuilder(
                context,
                index,
                widget.topList.length + index,
                widget.bottomList.elementAt(index),
              );
            },
            childCount: widget.bottomList.length,
          ),
        ),
        if (_bottomHasMore && widget.enabledBottomLoad)
          SliverToBoxAdapter(child: _buildLoadMoreView()),
      ],
    );
  }
}
