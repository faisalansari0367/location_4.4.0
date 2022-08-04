import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'select_role_state.dart';

class SelectRoleCubit extends Cubit<SelectRoleState> {
  SelectRoleCubit() : super(SelectRoleInitial());

  final roles = [
    'Producer',
    'Employee',
    'Visitor',
    'Transporter',
    'Receiver',
    'Contractor',
    'Supplier',
    'Agent',
  ];
}
