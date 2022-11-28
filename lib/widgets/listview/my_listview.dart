import 'package:background_location/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyListview<T> extends StatelessWidget {
  final bool isLoading, shrinkWrap, isPrimary, isAnimated;
  final ScrollController? controller;
  final Widget? emptyWidget;
  final Future<void> Function()? onRetry;

  final List<T> data;
  final Widget? spacing;
  final Widget Function(BuildContext, int) itemBuilder;
  final EdgeInsets? padding;

  const MyListview({
    Key? key,
    this.isLoading = false,
    this.isAnimated = true,
    this.emptyWidget,
    required this.data,
    required this.itemBuilder,
    this.spacing,
    this.shrinkWrap = false,
    this.isPrimary = false,
    this.onRetry,
    this.padding,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (isLoading) return _loader();
    // if (data.isEmpty) return Text('No data found');
    if (isAnimated) return _child();
    return AnimatedSwitcher(
      duration: kDuration,
      child: _child(),
    );
  }

  Widget _seperatorBuilder(BuildContext context, int index) {
    return spacing ?? Gap(2.height);
  }

  Widget _loader() => const Center(
        child: SizedBox.square(
          // dimension: 50.height,
          child: Center(
            child: CircularProgressIndicator(),
          ),
          // dimension: 40.height,
        ),
      );

  Widget _empty() {
    return Center(
      child: SizedBox.square(
        // dimension: 50.height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No data found',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: const Color.fromARGB(255, 241, 62, 62),
                ),
              ),
              Gap(2.height),
              MyElevatedButton(
                text: 'Retry',
                padding: EdgeInsets.zero,
                width: 20.width,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
        // dimension: 40.height,
      ),
    );
  }

  Widget _child() {
    if (isLoading) return _loader();
    if (data.isEmpty)
      return SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        controller: controller,
        child: emptyWidget ?? _empty(),
      );
    return ListView.separated(
      controller: controller,
      padding: padding,
      primary: isPrimary,
      itemCount: data.length,
      itemBuilder: itemBuilder,
      separatorBuilder: _seperatorBuilder,
      shrinkWrap: shrinkWrap,
    );
  }
}
