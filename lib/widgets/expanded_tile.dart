import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ExpandedTile extends StatefulWidget {
  final Widget title, subtitle, trailing;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isExpanded, hideArrow;

  const ExpandedTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.isExpanded = false,
    this.children = const [],
    this.hideArrow = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  State<ExpandedTile> createState() => _ExpandedTileState();
}

class _ExpandedTileState extends State<ExpandedTile> {
  bool isExpanded = false;

  @override
  void initState() {
    isExpanded = widget.isExpanded;
    super.initState();
  }

  void setIsExpanded(bool value) {
    isExpanded = value;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ExpandedTile oldWidget) {
    if (widget.isExpanded != oldWidget.isExpanded) {
      setIsExpanded(widget.isExpanded);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.children.isEmpty ? null : setIsExpanded(!isExpanded),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 20.sp),
        child: AnimatedSize(
          duration: 1000.milliseconds,
          curve: Curves.elasticOut,
          child: Column(
            crossAxisAlignment: widget.crossAxisAlignment,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: widget.crossAxisAlignment,
                      children: [
                        widget.title,
                        Gap(8.sp),
                        widget.subtitle,
                      ],
                    ),
                  ),
                  widget.trailing,
                  if (!widget.hideArrow)
                    Row(
                      children: [
                        Gap(30.sp),
                        _arrowIcon(),
                      ],
                    ),
                ],
              ),
              if (isExpanded) Gap(10.sp),
              if (isExpanded) ...widget.children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _arrowIcon() {
    return TweenAnimationBuilder<double>(
      duration: 500.milliseconds,
      curve: Curves.easeInOutBack,
      tween: Tween<double>(begin: !isExpanded ? 180 : 0, end: !isExpanded ? 0 : 180),
      child: Icon(Icons.keyboard_arrow_down),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * pi / 180,
          child: child,
        );
      },
    );
  }
}
