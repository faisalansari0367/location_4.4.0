import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/forms/global_questionnaire_form/global_questionnaire_form.dart';
import 'package:background_location/ui/forms/warakirri_entry_form/warakirri_entry_form.dart';
import 'package:flutter/src/widgets/framework.dart';

class FormsPage extends StatelessWidget {
  final String zoneId;
  final int? logRecordId;
  final LogbookEntry? logRecord;
  const FormsPage({super.key, required this.zoneId, this.logRecordId, this.logRecord});

  @override
  Widget build(BuildContext context) {
    final company = logRecord?.user?.company;

    switch (company?.trim().toLowerCase()) {
      case 'aurora':
        return WarakirriEntryFormPage(
          zoneId: zoneId,
          logrecordId: logRecordId,
        );

      default:
        return GlobalQuestionnaireFormPage(
          zoneId: zoneId,
          logrecordId: logRecordId,
        );
    }
  }
}
