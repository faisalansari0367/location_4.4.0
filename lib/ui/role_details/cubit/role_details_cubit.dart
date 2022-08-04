import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'role_details_state.dart';

class RoleDetailsCubit extends Cubit<RoleDetailsState> {
  final String role;
  RoleDetailsCubit(this.role) : super(RoleDetailsInitial());
}
