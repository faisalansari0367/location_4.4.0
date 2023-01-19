import 'package:api_repo/api_repo.dart';
import 'package:bioplus/features/drawer/view/drawer_page.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/network_error_dialog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final String? email;
  final AuthRepo auth;
  final LocalApi localApi;
  LoginCubit({
    required this.localApi,
    required AuthRepo repository,
    this.email,
  })  : auth = repository,
        super(const LoginState()) {
    emailController = TextEditingController(text: email);
    state.copyWith(email: email);
    final connectivity = MyConnectivity();
    connectivity.connectionStream.listen((event) {
      if (isClosed) return;
      emit(state.copyWith(isConnected: event));
    });
  }

  late TextEditingController emailController;

  void onChangedEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void onChangedPassword(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> onPressedLogin() async {
    try {
      emit(state.copyWith(isLoading: true));
      final model = SignInModel(email: emailController.text, password: state.password);
      final result = await (state.isConnected ? auth.signIn(data: model) : localApi.signIn(data: model));

      result.when(
        success: (data) {
          Get.offAll(() => const DrawerPage());
          Get.to(() => const MapsPage());
        },
        failure: (error) {
          DialogService.showDialog(
            child: NetworkErrorDialog(
              message: NetworkExceptions.getErrorMessage(error),
              onCancel: Get.back,
            ),
          );
        },
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void clearError() => emit(state.copyWith(error: ''));
}
