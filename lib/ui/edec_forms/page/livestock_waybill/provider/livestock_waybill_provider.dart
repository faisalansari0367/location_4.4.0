import 'package:bioplus/constants/index.dart';
import 'package:bioplus/features/webview/flutter_webview.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:open_file_safe/open_file_safe.dart';

class LivestockWaybillNotifier extends BaseModel {
  LivestockWaybillNotifier(super.context) {
    _formsStorageService = FormsStorageService(api);
  }

  late FormsStorageService _formsStorageService;

  String? selectedState;

  final pdfs = {
    'sa':
        'https://pir.sa.gov.au/__data/assets/pdf_file/0005/265082/Alternative_Cattle_Movement_Document_nov_2015.pdf',
    // 'NT': 'https://nt.gov.au/__data/assets/pdf_file/0011/209387/example-of-how-to-fill-in-a-.pdf',
    'nt':
        'https://nt.gov.au/__data/assets/pdf_file/0011/209387/example-of-how-to-fill-in-a-waybill.pdf',
    'QLD':
        'https://www.daf.qld.gov.au/__data/assets/pdf_file/0004/377806/BQ-0083-Movement-record.pdf',
    'WA':
        'https://www.agric.wa.gov.au/livestock-movement-identification/downloading-and-completing-plain-livestock-waybills',
    'VIC':
        'https://agriculture.vic.gov.au/livestock-and-animals/national-livestock-identification-system/movement-documentation#h2-2',
    'TAS': '',
  };

  Future<void> selectState(String? state) async {
    selectedState = state;
    final value = pdfs[state!];
    if (value?.isNotEmpty ?? true) {
      final isPdf = value!.endsWith('.pdf');
      isPdf
          ? await _downloadPdf(value)
          : Get.to(() => Webview(url: value, title: 'Livestock Waybill'));
    } else {
      DialogService.error('No PDF currently available for $state');
    }
    notifyListeners();
  }

  Future<void> _downloadPdf(String url) async {
    // Get.to(() => Webview(url: url, title: 'Livestock Waybill'));
    try {
      final result = await apiService.downloadPdf(url);
      final file = await _formsStorageService.downloadPdf(
          bytes: result, fileName: '$selectedState Waybill',);
      OpenFile.open(file.path);
    } catch (e) {
      DialogService.error('Something went wrong');
    }
  }
}
