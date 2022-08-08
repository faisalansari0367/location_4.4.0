/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/mail_sent.json
  String get mailSent => 'assets/animations/mail_sent.json';

  /// File path: assets/animations/network_error.json
  String get networkError => 'assets/animations/network_error.json';

  /// File path: assets/animations/welcome.json
  String get welcome => 'assets/animations/welcome.json';
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/App icon.png
  AssetGenImage get appIcon => const AssetGenImage('assets/icons/App icon.png');

  /// File path: assets/icons/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/icons/background.png');

  $AssetsIconsBottomNavbarGen get bottomNavbar =>
      const $AssetsIconsBottomNavbarGen();

  /// File path: assets/icons/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/icons/logo.png');
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/forgot_password.jpeg
  AssetGenImage get forgotPassword =>
      const AssetGenImage('assets/images/forgot_password.jpeg');

  /// File path: assets/images/login.jpeg
  AssetGenImage get login => const AssetGenImage('assets/images/login.jpeg');

  /// File path: assets/images/signup.jpeg
  AssetGenImage get signup => const AssetGenImage('assets/images/signup.jpeg');
}

class $AssetsIconsBottomNavbarGen {
  const $AssetsIconsBottomNavbarGen();

  /// File path: assets/icons/bottom_navbar/color-picker.png
  AssetGenImage get colorPicker =>
      const AssetGenImage('assets/icons/bottom_navbar/color-picker.png');

  /// File path: assets/icons/bottom_navbar/home.png
  AssetGenImage get home =>
      const AssetGenImage('assets/icons/bottom_navbar/home.png');

  /// File path: assets/icons/bottom_navbar/map.png
  AssetGenImage get map =>
      const AssetGenImage('assets/icons/bottom_navbar/map.png');

  /// File path: assets/icons/bottom_navbar/square.png
  AssetGenImage get square =>
      const AssetGenImage('assets/icons/bottom_navbar/square.png');
}

class Assets {
  Assets._();

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
