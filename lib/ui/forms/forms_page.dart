import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/forms/global_questionnaire_form/global_questionnaire_form.dart';
import 'package:bioplus/ui/forms/warakirri_entry_form/warakirri_entry_form.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../maps/models/polygon_model.dart';

class FormsPage extends StatelessWidget {
  final String zoneId;
  final int? logRecordId;
  final LogbookEntry? logRecord;
  final PolygonModel? polygon;

  const FormsPage({
    super.key,
    required this.zoneId,
    this.logRecordId,
    this.logRecord,
    this.polygon,
  });

  @override
  Widget build(BuildContext context) {
    final company = polygon?.companyOwner;
    log('zone company name $company');
    switch (company?.trim().toLowerCase()) {
      case 'aurora':
      case 'warakirri':
        return WarakirriEntryFormPage(
          zoneId: zoneId,
          logrecordId: logRecordId,
          polygon: polygon!,
        );

      default:
        return GlobalQuestionnaireFormPage(
          zoneId: zoneId,
          logrecordId: logRecordId,
        );
    }
  }
}
