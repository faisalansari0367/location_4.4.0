import 'dart:convert';

import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';

class QRCodeImage extends StatefulWidget {
  final String image;
  const QRCodeImage({super.key, required this.image});

  @override
  State<QRCodeImage> createState() => _QRCodeImageState();
}

class _QRCodeImageState extends State<QRCodeImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55.width,
      height: 55.width,
      child: _qrCode(),
    );
  }

  Widget _qrCode() {
    return Image.memory(
      base64Decode(widget.image),
      fit: BoxFit.fitHeight,
      width: 75.width,
      height: 75.width,
    );
  }
}
