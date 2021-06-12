library scroll_loadmore;

import 'package:flutter/widgets.dart';

class ScrollLoadMore extends StatefulWidget {
  final Widget child;
  final VoidCallback onLoadMore;
  final bool enable;
  final bool initLoadMore;
  final Axis scrollDirection;
  final int scrollOffset;

  const ScrollLoadMore(
      {Key? key,
        required this.child,
        required this.onLoadMore,
        this.enable = true,
        this.initLoadMore = true,
        this.scrollDirection = Axis.vertical,
        this.scrollOffset = 0})
      : super(key: key);

  @override
  _ScrollLoadMoreState createState() => _ScrollLoadMoreState();
}

class _ScrollLoadMoreState extends State<ScrollLoadMore> {

  @override
  void initState() {
    super.initState();
    if (widget.enable && widget.initLoadMore) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => widget.onLoadMore.call());
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (widget.enable && widget.scrollDirection == notification.metrics.axis) {
          if (widget.scrollOffset > 0 &&
              notification is ScrollUpdateNotification) {
            double offset = notification.metrics.maxScrollExtent -
                notification.metrics.pixels;
            if (offset <= widget.scrollOffset) {
              _loadMore();
            }
          }
          if (notification is OverscrollNotification) {
            if (notification.overscroll > 0) {
              _loadMore();
            }
          }
        }
        return false;
      },
      child: widget.child,
    );
  }

  void _loadMore() {
    widget.onLoadMore.call();
  }
}
