import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/envd/cubit/graphql_client.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPicNotifier extends BaseModel {
  AddPicNotifier(super.context, {this.model, this.updatePic = false}) {
    if (model == null) return;
    emit(
      state.copyWith(
        pic: model?.pic,
        ngr: model?.ngr,
        companyName: model?.company,
        propertyName: model?.propertyName,
        owner: model?.owner,
        street: model?.street,
        town: model?.town,
        state: model?.state,
        postcode: model?.postcode == null ? null : model!.postcode!.toString(),
        lpaUsername: model?.lpaUsername,
        nlisPassword: model?.nlisPassword,
        msaNumber: model?.msaNumber,
        nfasAccreditationNumber: model?.nfasAccreditationNumber,
      ),
    );
  }

  final PicModel? model;
  final bool updatePic;

  AddPicParams state = const AddPicParams();
  final lpaUsernameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void onPicChanged(String value) {
    emit(
      state.copyWith(pic: value, lpaUsername: value),
    );
  }

  void onNgrChanged(String value) => emit(state.copyWith(ngr: value));

  void onCompanyChanged(String value) =>
      emit(state.copyWith(companyName: value.split(',')));

  void onPropertyChanged(String value) =>
      emit(state.copyWith(propertyName: value));

  void onOwnerChanged(String value) => emit(state.copyWith(owner: value));

  void onStreetChanged(String value) => emit(state.copyWith(street: value));

  void onTownChanged(String value) => emit(state.copyWith(town: value));

  void onStateChanged(String value) => emit(state.copyWith(state: value));

  void onPostCodeChanged(String value) => emit(state.copyWith(postcode: value));

  void onLPAusernameChanged(String value) {
    emit(state.copyWith(lpaUsername: value));
  }

  void onLpaUsernameTapped(_) {
    String lpaUserName = state.lpaUsername ?? '';
    if (lpaUserName.length == 8) {
      lpaUserName += '-';
    }
    lpaUsernameController.text = lpaUserName;
  }

  void onNlisPasswordChanged(String p1) {
    emit(state.copyWith(nlisPassword: p1));
  }

  void onMsaNumberChanged(String p1) {
    emit(state.copyWith(msaNumber: p1));
  }

  void onNFasAccreditationNumberChanged(String p1) {
    emit(state.copyWith(nfasAccreditationNumber: p1));
  }

  Future<bool> validateLpaCreds() async {
    if (state.lpaUsername == null) {
      DialogService.error('Please enter a valid PIC');
      return false;
    }

    if (state.lpaPassword == null) {
      DialogService.error('Please enter a valid password');
      return false;
    }

    try {
      final client = GraphQlClient(userData: api.getUserData());
      final result = await client.getEnvdToken(
        state.lpaUsername!,
        state.lpaPassword!,
      );

      print(result);

      return true;
    } on Exception catch (e) {
      DialogService.error(e.toString());
      return false;
    }
  }

  Future<void> submit() async {
    if (state.lpaPassword != null && state.lpaPassword != null) {
      if (!await validateLpaCreds()) {
        return;
      }
    }

    final isFormValidated = formKey.currentState!.validate();
    if (!isFormValidated) {
      return;
    }
    formKey.currentState!.save();

    final result = updatePic
        ? api.updatePic(params: state, picId: model!.id)
        : api.createPic(params: state);

    (await result).when(
      success: success,
      failure: failure,
    );
  }

  void emit(AddPicParams state) {
    this.state = state;
    notifyListeners();
  }

  Object? success(PicModel data) {
    final message = updatePic ? 'Updated' : 'Created';

    DialogService.success(
      'Pic $message successfully',
      onCancel: () => Get.close(2),
    );
    return null;
  }

  void failure(NetworkExceptions error) {
    final errorMessage = NetworkExceptions.getErrorMessage(error);
    const message = 'duplicate key value';

    if (errorMessage.contains(message)) {
      DialogService.error(
        'PIC already exists, please try with a different PIC',
      );
      return;
    }

    DialogService.failure(error: error);
    return;
  }

  void onLpaPasswordChanged(String p1) {
    emit(state.copyWith(lpaPassword: p1));
  }
}
