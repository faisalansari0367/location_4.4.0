import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/features/webview/flutter_webview.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/dialogs/dialog_service.dart';

class LinksView extends StatelessWidget {
  const LinksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Links'),
      ),
      body: Padding(
        padding: kPadding,
        child: AutoSpacing(
          spacing: Gap(15.h),
          children: [
            MyListTile(
              text: 'Farm Biosecurity'.toUpperCase(),
              title: Align(
                alignment: Alignment.centerLeft,
                // width: 100.w,
                child: Image.asset(
                  'assets/images/farm_bio_security_logo.png',
                  height: 30.w,
                ),
              ),
              onTap: () async => Get.to(
                () => const Webview(
                  url: 'https://www.farmbiosecurity.com.au/',
                  title: 'Farm Biosecurity',
                ),
              ),
            ),
            MyListTile(
              text: 'SAFE AND RESPONSIBLE ANIMAL TREATMENTS'.capitalize!,
              onTap: () async => await openPdf(
                context,
                'https://www.integritysystems.com.au/globalassets/isc/pdf-files/lpa-documents/lpa-records-templates/lpa-02-livestock-treatment-record-form.pdf',
              ),
            ),
            MyListTile(
              text: 'Livestock treatment record'.capitalize!,
              onTap: () async => await openPdf(
                context,
                'https://www.integritysystems.com.au/globalassets/isc/pdf-files/lpa-documents/lpa-records-templates/lpa-02-livestock-treatment-record-form.pdf',
              ),
            ),
            MyListTile(
              text: 'Chemical inventory'.capitalize!,
              onTap: () async => await openPdf(
                context,
                'https://www.integritysystems.com.au/globalassets/isc/pdf-files/lpa-documents/lpa-records-templates/lpa-03-chemical-inventory-form.pdf',
              ),
            ),
            MyListTile(
              text: 'Carbon Farming'.capitalize!,
              onTap: () async => await openPdf(
                context,
                'https://agriculture.vic.gov.au/__data/assets/pdf_file/0010/578719/Cents-of-Carbon.pdf',
              ),
            ),
            MyListTile(
              text: 'iTRAK'.toUpperCase(),
              title: Align(
                alignment: Alignment.centerLeft,
                // width: 100.w,
                child: Image.asset(
                  'assets/images/itrak.jpeg',
                  height: 50.w,
                ),
              ),
              onTap: () async => Get.to(
                () => const Webview(
                  url: 'https://www.i-trak.com.au/',
                  title: 'iTRAK',
                ),
              ),
            ),
            MyListTile(
              text: 'iTRAKassets',
              title: Align(
                alignment: Alignment.centerLeft,
                // width: 100.w,
                child: Image.asset(
                  'assets/icons/itrak_assets_logo.webp',
                  height: 50.w,
                ),
              ),
              onTap: () async => Get.to(
                () => const Webview(
                  url: 'https://itrakassets.com/',
                  title: 'iTRAKassets',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openPdf(BuildContext context, String url) async {
    final api = context.read<Api>();
    final result = await api.openPdf(url);
    result.when(
      success: (s) async {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(s);
        await OpenFile.open(file.path);
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }
}
