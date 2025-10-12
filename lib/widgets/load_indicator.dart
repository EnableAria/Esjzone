import 'dart:math';
import 'package:flutter/material.dart';

typedef LoadCallback = Future<void> Function();

// 上拉加载组件
class LoadIndicator extends StatefulWidget {
  const LoadIndicator({
    required this.child,
    required this.onLoad,
    this.triggerDistance = 80.0,
    this.idleTitle,
    this.canLoadTitle,
    this.loadingTitle,
    this.noDataTitle,
    super.key,
  });

  final Widget child;
  final LoadCallback? onLoad; // 上拉加载回调
  final double triggerDistance; // 上拉加载触发阈值
  final String? idleTitle;
  final String? canLoadTitle;
  final String? loadingTitle;
  final String? noDataTitle;

  @override
  State<LoadIndicator> createState() => _LoadIndicatorState();
}

class _LoadIndicatorState extends State<LoadIndicator> {
  double _dragOffset = 0.0; // 当前拖动偏移量
  bool _isLoading = false; // 加载标记

  // 加载内容
  Future<void> _triggerLoad() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    if (widget.onLoad != null) await widget.onLoad!();

    if (mounted) {
      setState(() {
        _isLoading = false;
        _dragOffset = 0.0; // 重置拖动偏移量
      });
    }
  }

  // 滚动监听回调
  bool _handleScrollNotification(ScrollNotification notification) {
    if (!_isLoading) {
      // 超出可滚动范围的向上滚动
      if (notification is OverscrollNotification
          && _dragOffset < widget.triggerDistance
          && notification.overscroll > 0 // 上拉
          && notification.metrics.pixels >= notification.metrics.maxScrollExtent// 位于底部
      ) {
        setState(() {
          _dragOffset = min(_dragOffset += notification.overscroll, widget.triggerDistance); // 累积拖动距离
        });
      }
      // 处于可滚动范围的向下滚动
      else if (notification is ScrollUpdateNotification
          && _dragOffset > 0
          && notification.scrollDelta != null
          && notification.scrollDelta! < 0 // 下拉
      ) {
        setState(() {
          _dragOffset = max(_dragOffset += notification.scrollDelta!, 0);
        });
      }
      // 滚动结束重置拖动距离
      else if (notification is ScrollEndNotification) {
        // 拖动距离超过阈值时加载
        if (_dragOffset >= widget.triggerDistance) { _triggerLoad(); }
        else if (_dragOffset > 0.0) { setState(() {_dragOffset = 0.0; }); }
      }
    }

    return false; // 允许通知继续传递
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: widget.child,
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: (_dragOffset <= 0 && !_isLoading)
                ? const SizedBox.shrink()
                : Transform.translate(
              offset: Offset(0, -_dragOffset / 2),
              child: widget.onLoad == null
                ? Text(widget.noDataTitle ?? "没有内容")
                : _isLoading
                  ? wIconText(icon: null, title: widget.loadingTitle ?? "加载中")
                  : _dragOffset < widget.triggerDistance
                    ? wIconText(icon: Icons.arrow_upward, title: widget.idleTitle ?? "继续上拉")
                    : wIconText(icon: Icons.arrow_downward, title: widget.canLoadTitle ?? "松开加载")
            ),
          ),
        ),
      ],
    );
  }

  Widget wIconText({required IconData? icon, required String title}) {
    return Row(
      spacing: 8.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon != null
            ? Icon(icon, size: 32, color: Colors.grey)
            : SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 3)),
        Text(title, style: TextStyle(fontSize: 14))
      ],
    );
  }
}