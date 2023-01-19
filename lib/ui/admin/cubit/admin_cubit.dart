import 'package:bioplus/ui/admin/cubit/admin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit()
      : super(
          AdminState(
            options: [
              'Users',
              'Geofences',
              'Visitor Log Books',
              'Transporters',
              'Consignees',
              'eNVD',
              'Mapping',
            ],
          ),
        );
}
