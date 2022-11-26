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
        title: Text(item.form.isWarakirriFarm ? 'Warakirri Entry Form' : 'Declaration Form'),
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
        children: item.form.isWarakirriFarm ? _buildWarakirriForm() : _buildChildrens(),
      ),
    );
  }

  List<Widget> _buildWarakirriForm() {
    return [
      _card(item.form.warakirriKeys.isPeopleTravelingWith, getNames()),
      _card(item.form.warakirriKeys.isFluSymptoms, getValue(item.form.isFluSymptoms)),
      _card(item.form.warakirriKeys.isOverSeaVisit, getValue(item.form.isOverSeaVisit)),
      _card(item.form.warakirriKeys.additionalInfo, getValue(item.form.additionalInfo)),
      _card(item.form.warakirriKeys.hasBeenInducted, getValue(item.form.hasBeenInducted)),
      _card(item.form.warakirriKeys.isConfinedSpace, getValue(item.form.isConfinedSpace)),
      _card(item.form.warakirriKeys.warakirriFarm, item.form.warakirriFarm),
    ];
  }

  String getNames() {
    return (item.form.usersTravellingAlong?.isEmpty ?? true) ? 'No' : item.form.usersTravellingAlong!.join(', ');
  }

  _buildChildrens() {
    final form = item.form;
    return [
      _card(
        form.keys.isPeopleTravelingWith,
        (form.usersTravellingAlong?.isEmpty ?? true) ? 'No' : form.usersTravellingAlong!.join(', '),
      ),
      // if(form.isQfeverVaccinated != null)
      _card(form.keys.isQfeverVaccinated, getValue(form.isQfeverVaccinated!)),
      _card(form.keys.isOverSeaVisit, getValue(form.isOverSeaVisit)),
      _card(form.keys.isFluSymptoms, getValue(form.isFluSymptoms)),
      _card(form.keys.isOwnerNotified, getValue(form.isOwnerNotified)),
      _card(
        form.keys.expectedDepartureDate,
        MyDecoration.formatDate(form.expectedDepartureDate) + ' ' + MyDecoration.formatTime(form.expectedDepartureDate),
      ),
      _card(form.keys.rego, form.rego),
      _card(form.keys.riskRating, form.riskRating),
      Gap(10.h),
      if (form.signature != null)
        SignatureWidget(
          signature: form.signature,
          isEditable: false,
        ),
      Gap(20.h),
    ];
  }

  String? getValue(bool? value) {
    return value == null
        ? null
        : value
            ? 'Yes'
            : 'No';
  }

  Container _card(String key, String? value2) {
    if (value2 == null) return Container();
    // if (value == false && value2 == null) return Container();
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
            initialValue: value2,
          ),
        ],
      ),
    );
  }
}
