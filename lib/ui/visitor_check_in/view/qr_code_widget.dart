import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';

class QRCodeImage extends StatefulWidget {
  const QRCodeImage({super.key});

  @override
  State<QRCodeImage> createState() => _QRCodeImageState();
}

class _QRCodeImageState extends State<QRCodeImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75.width,
      height: 75.width,
      child: _qrCode(),
    );
  }

  Widget _qrCode() {
    return Image.asset(
      'assets/images/app_link_qr_code.png',
      fit: BoxFit.fitHeight,
      width: 75.width,
      height: 75.width,
    );
  }
}
