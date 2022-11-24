import 'package:api_repo/api_repo.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../constants/index.dart';

class LogbookDetails extends StatelessWidget {
  final LogbookEntry item;
  const LogbookDetails({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        elevation: 5,
        title: Text('Declaration Form'),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // CreatePDf.printDeclarationForm(item);
          //   },
          //   icon: Icon(Icons.picture_as_pdf),
          // ),
          Gap(20.w),
        ],
        // showDivider: true,
        // backgroundColor: context.theme.primaryColor,
      ),
      body: ListView(
        padding: kPadding,
        children: _buildChildrens(),
      ),
    );
  }

  _buildChildrens() {
    final form = item.form;
    return [
      _card(form.keys.isPeopleTravelingWith, form.isPeopleTravelingWith,
          value2: form.usersTravellingAlong.isEmpty ? 'No' : form.usersTravellingAlong.join(', ')),
      _card(form.keys.isQfeverVaccinated, form.isQfeverVaccinated),
      _card(form.keys.isOverSeaVisit, form.isOverSeaVisit),
      _card(form.keys.isFluSymptoms, form.isFluSymptoms),
      _card(form.keys.isOwnerNotified, form.isOwnerNotified),
      _card(form.keys.expectedDepartureDate, false, value2: MyDecoration.formatDate(form.expectedDepartureDate)),
      _card(form.keys.expectedDepartureTime, false, value2: MyDecoration.formatTime(form.expectedDepartureTime)),
      _card(form.keys.rego, false, value2: form.rego),
      _card(form.keys.riskRating, false, value2: form.riskRating),
      Gap(10.h),
      SignatureWidget(
        signature: form.signature,
        isEditable: false,
      ),
      Gap(20.h),
    ];
  }

  Container _card(String key, bool value, {String? value2}) {
    return Container(
      decoration: MyDecoration.decoration(shadow: false, color: Colors.grey.shade100),
      padding: kPadding,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.form.question(key),
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
              fontSize: 16.h,
            ),
          ),
          TextFormField(
            enabled: false,
            initialValue: value2 ?? (value ? 'Yes' : 'No'),
          ),
        ],
      ),
    );
  }
}
