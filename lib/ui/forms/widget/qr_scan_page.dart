import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class QrScanPage extends StatelessWidget {
  final String? qrData;
  const QrScanPage({Key? key, required this.qrData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (qrData != null) Container(),
        // QrImage(
        //   data: qrData!,
        //   version: QrVersions.auto,
        // ),
        Text('Scan qr forms'),
      ],
    );
  }
}
