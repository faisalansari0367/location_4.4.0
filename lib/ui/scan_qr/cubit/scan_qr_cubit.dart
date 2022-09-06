import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scan_qr_state.dart';

class ScanQrCubit extends Cubit<ScanQrState> {
  ScanQrCubit() : super(ScanQrInitial());
}
