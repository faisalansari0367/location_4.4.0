import 'package:bioplus/widgets/image/shimmer_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/constans.dart';
import '../../constants/my_decoration.dart';

class MyNetworkImage extends StatelessWidget {
  final String? urlToImage;
  final bool isLoading, isCircle, useImageBuilder, autoHeight;
  final void Function()? onTap, onLongPress;
  final double? height, width;
  final BoxFit fit;
  const MyNetworkImage({
    Key? key,
    this.isLoading = false,
    this.isCircle = false,
    this.autoHeight = false,
    this.useImageBuilder = true,
    this.urlToImage,
    this.height,
    this.onTap,
    this.onLongPress,
    this.fit = BoxFit.cover,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: CachedNetworkImage(
        fit: fit,
        placeholder: placeHolder,
        errorWidget: errorWidget,
        height: height,
        width: width,
        imageBuilder: useImageBuilder ? imageBuilder : null,
        imageUrl: urlToImage!,
        // imageUrl: urlToImage!,
      ),
    );
  }

  Widget imageBuilder(context, imageProvider) {
    return ClipRRect(
      borderRadius: isCircle ? MyDecoration.inputBorderRadius : kBorderRadius,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
    );
  }

  Widget placeHolder(BuildContext context, String _) => const ShimmerAnimation();
  Widget errorWidget(BuildContext context, String _, dynamic __) => const Icon(Icons.error_outline_outlined);
}
