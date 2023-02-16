import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/add_pic/add_pic.dart';
import 'package:bioplus/ui/envd/view/envd_view.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:cross_file/cross_file.dart';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EnvdCubit extends BaseModel {
  bool _isFetching = false;
  List<Items> _consignments = [];
  List<Items> get consignments => _consignments;

  EnvdCubit(super.context) {
    api.consignmentsStream.listen((event) {
      _consignments = event.items ?? [];
      notifyListeners();
    });
  }

  bool _isNull(String? value) => value == null || value.isEmpty;

  bool hasCredentials(PicModel pic) {
    if (_isNull(pic.lpaUsername) || _isNull(pic.lpaPassword)) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> validateCreds(PicModel pic) async {
    if (!hasCredentials(pic)) {
      await Get.dialog(
        StatusDialog(
          lottieAsset: 'assets/animations/error.json',
          message:
              "Please provide valid LPA credentials in your PIC details to use this feature.",
          onContinue: () async {
            Get.back();
            Get.to(
              () => AddPicPage(
                pic: pic,
                updatePic: true,
              ),
            );
          },
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> generateCsv() async {
    generateEnvdCSV(consignments);
  }

  bool get isLoading => _isFetching && _consignments.isEmpty;

  Future<void> onPicSelect(PicModel pic) async {
    if (await validateCreds(pic)) {
      Get.to(
        () => ChangeNotifierProvider.value(
          value: this,
          child: const EnvdView(),
        ),
      );
      _isFetching = true;
      notifyListeners();
      final result = await api.getEnvdForms(pic.lpaUsername!, pic.lpaPassword!);
      result.when(success: success, failure: failure);
      _isFetching = false;
      notifyListeners();
    }
  }

  bool get isVisitor => api.getUserData()?.role == 'Visitor';

  Stream<List<PicModel>> get picsStream => api.picsStream;

  void failure(NetworkExceptions error) {
    DialogService.failure(error: error);
  }

  void success(Consignments data) {}

  Future<void> generateEnvdCSV(List<Items> consignments) async {
    final headers = [
      'Consignment',
      'Created',
      'From PIC',
      'To PIC',
      'Species',
      'Breed',
      'Quantity',
      'Accreditations',
      'Transporter',
      'Status'
    ];
    final newHeaders = headers.map((e) => e.toUpperCase()).toList();
    final rows = consignments
        .map(
          (item) => [
            item.number ?? '',
            item.createdAt(),
            item.fromPIC,
            item.toPIC,
            item.species ?? '',
            '',
            item.getQuantity(),
            item.getAccredentials(),
            item.transporter,
            item.status ?? '',
          ],
        )
        .toList();
    rows.insert(0, newHeaders);
    final data = const ListToCsvConverter().convert(rows);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/envd_csv-${DateTime.now()}.csv";
    final File file = File(path);
    await file.writeAsString(data);
    await Share.shareXFiles([XFile(file.path)]);
  }
}
