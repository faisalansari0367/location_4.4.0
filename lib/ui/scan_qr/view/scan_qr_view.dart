import 'dart:io';

import 'package:background_location/ui/scan_qr/widgets/show_scanned_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../../../widgets/dialogs/error.dart';

class ScanQrView extends StatefulWidget {
  //  final String? qrData;
  // final void Function(Barcode)? onData;

  const ScanQrView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            top: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // IconButton(
                //   icon: Icon(Icons.arrow_back),
                //   color: Colors.grey[400],
                //   onPressed: () async {
                //     // Get.back();
                //   },
                // ),
                // Spacer(),
                FutureBuilder(
                  future: controller?.getFlashStatus(),
                  initialData: false,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    return IconButton(
                      icon: snapshot.data ? const Icon(Icons.flash_off) : const Icon(Icons.flash_on),
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      color: Colors.grey[400],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    final scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        // overlayColor: Colors.transparent,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    // final otpController = Get.find<OTPTeacherController>();
    var getResult = false;

    controller.scannedDataStream.listen((scanData) {
      if (getResult) return;
      setState(() {
        if (scanData.code == null) {
          DialogService.showDialog(
            child: ErrorDialog(message: 'Barcode not found', onTap: Get.back),
          );
        } else {
          if (scanData.code is String) {
            Get.to(() => ShowScannedData(data: scanData.code!));
          }
          // final data = jsonDecode(scanData.code!);
          // print(data is List<Map>);

          // // Get.to(() => FormsPage(questions: List<Map>.from(data)));
          // if (data is List<Map>) {
          //   print(data);
          // }
          // debugPrint('Barcode found! $code');

        }
        // Get.back();
        // if (widget.onData != null) {
        //   widget.onData!(scanData);
        // }
        result = scanData;
        // print(scanData.code);

        getResult = true;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
