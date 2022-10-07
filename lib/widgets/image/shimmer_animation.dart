import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/index.dart';

class ShimmerAnimation extends StatelessWidget {
  final double? width, height;
  const ShimmerAnimation({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageBgColor = theme.cardColor;
    final shimmer = Container(
      width: width ?? 100.width,
      height: height ?? 100.height,
      decoration: BoxDecoration(
        color: imageBgColor,
        borderRadius: kBorderRadius,
      ),
    );
    final placeHolder = Shimmer.fromColors(
      highlightColor: imageBgColor,
      // baseColor: theme.colorScheme.secondary,
      baseColor: Colors.grey.shade300,
      child: shimmer,
    );
    return placeHolder;
  }
}
