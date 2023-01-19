import 'package:bioplus/ui/scan_qr/scan_qr.dart';
import 'package:bioplus/ui/scan_qr/view/scan_qr_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanQrPage extends StatelessWidget {
  const ScanQrPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanQrCubit(),
      child: const ScanQrView(),
    );
  }
}