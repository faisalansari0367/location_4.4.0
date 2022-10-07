import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../scan_qr.dart';
import 'scan_qr_view.dart';

class ScanQrPage extends StatelessWidget {
  const ScanQrPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanQrCubit(),
      child: const ScanQrView(),
    );
  }
}