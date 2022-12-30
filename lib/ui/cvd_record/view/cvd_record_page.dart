import 'package:bioplus/theme/color_constants.dart';
import 'package:bioplus/ui/cvd_record/provider/provider.dart';
import 'package:bioplus/ui/cvd_record/widgets/cvd_record_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// {@template cvd_record_page}
/// A description for CvdRecordPage
/// {@endtemplate}
class CvdRecordPage extends StatelessWidget {
  /// {@macro cvd_record_page}
  const CvdRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CvdRecordNotifier(context),
      child: const Scaffold(
        appBar: MyAppBar(
          backgroundColor: kPrimaryColor,
          title: Text('CVD Record'),
          elevation: 3,
        ),
        body: CvdRecordView(),
      ),
    );
  }
}

/// {@template cvd_record_view}
/// Displays the Body of CvdRecordView
/// {@endtemplate}
class CvdRecordView extends StatelessWidget {
  /// {@macro cvd_record_view}
  const CvdRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CvdRecordBody();
  }
}
