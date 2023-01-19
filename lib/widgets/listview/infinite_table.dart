import 'package:bioplus/helpers/callback_debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class InfiniteTable extends StatefulWidget {
  final Widget table;
  final ScrollController? controller;
  final Future<void> Function() onRefresh;
  final bool hasReachedMax;
  const InfiniteTable(
      {super.key, required this.table, this.controller, required this.onRefresh, this.hasReachedMax = false,});

  @override
  State<InfiniteTable> createState() => _InfiniteTableState();
}

class _InfiniteTableState extends State<InfiniteTable> {
  late ScrollController _controller;
  final CallbackDebouncer _debouncer = CallbackDebouncer(100.milliseconds);
  @override
  void initState() {
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_listener);
    super.initState();
  }

  void _listener() {
    if (isAtEnd) {
      if (!_isScrollingDown) return;
      if (widget.hasReachedMax) return;
      _debouncer.call(() {
        widget.onRefresh();
      });
    }
  }

  bool get isAtEnd => _controller.position.pixels >= _controller.position.maxScrollExtent - 100;
  bool get _isScrollingDown => _controller.position.userScrollDirection == ScrollDirection.reverse;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: _controller,
        child: widget.table,
      ),
    );
  }
}
