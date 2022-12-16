import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';

class QrCodeGenerator extends StatefulWidget {
  final String qrData;
  const QrCodeGenerator({super.key, required this.qrData});

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
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
