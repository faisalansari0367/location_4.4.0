import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_state.dart';

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
