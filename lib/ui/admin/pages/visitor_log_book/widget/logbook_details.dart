import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants/index.dart';

class LogbookDetails extends StatefulWidget {
  final LogbookEntry item;
  const LogbookDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<LogbookDetails> createState() => _LogbookDetailsState();
}

class _LogbookDetailsState extends State<LogbookDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        elevation: 5,
        title: Text(widget.item.form.isWarakirriFarm ? 'Warakirri Entry Form' : 'Declaration Form'),
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
        children: widget.item.form.isWarakirriFarm ? _buildWarakirriForm() : _buildChildrens(),
      ),
    );
  }

  List<Widget> _buildWarakirriForm() {
    return [
      _userInfo(context),
      _card(widget.item.form.warakirriKeys.isPeopleTravelingWith, getNames()),
      _card(widget.item.form.warakirriKeys.isFluSymptoms, getValue(widget.item.form.isFluSymptoms)),
      _card(widget.item.form.warakirriKeys.isOverSeaVisit, getValue(widget.item.form.isOverSeaVisit)),
      _card(widget.item.form.warakirriKeys.hasBeenInducted, getValue(widget.item.form.hasBeenInducted)),
      _card(widget.item.form.warakirriKeys.isConfinedSpace, getValue(widget.item.form.isConfinedSpace)),
      _card(widget.item.form.warakirriKeys.additionalInfo, widget.item.form.additionalInfo),
      _card(widget.item.form.warakirriKeys.warakirriFarm, widget.item.form.warakirriFarm),
      // _card(widget.item.form.warakirriKeys.expectedDepartureDate, getDateTime(widget.item.form.expectedDepartureDate)),
      // _card(widget.item.form.warakirriKeys.fullName, (widget.item.user?.fullName)),
      // _card(widget.item.form.warakirriKeys.companyName, (widget.item.user?.company)),
      // _card(widget.item.form.warakirriKeys.phoneNumber, (widget.item.user?.phoneNumber)),
    ];
  }

  Widget _userInfo(BuildContext context) {
    return Container(
      // padding: kPadding,
      margin: kPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entry Details',
            style: context.textTheme.headline6,
          ),
          Gap(20.h),
          _buildRow('Full Name', widget.item.user?.fullName ?? '', 'Company Name', widget.item.user?.company ?? ''),
          Gap(20.h),
          _buildRow(
            'Phone Number',
            (widget.item.user?.countryCode ?? '') + ' ' + (widget.item.user?.phoneNumber ?? ''),
            'Expected Departure Time',
            getDateTime(widget.item.form.expectedDepartureDate),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String field1, String value1, String field2, String value2) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildText(field1, value1),
        ),
        Spacer(),
        Expanded(
          flex: 3,
          child: _buildText(field2, value2),
        ),
      ],
    );
  }

  Widget _buildText(String text, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          text,
          maxLines: 1,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        Gap(5.h),
        AutoSizeText(
          value,
          maxLines: 1,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String getDateTime(DateTime? dateTime) {
    return '${MyDecoration.formatDate(dateTime)}  ${MyDecoration.formatTime(dateTime)}';
  }

  String getNames() {
    return (widget.item.form.usersTravellingAlong?.isEmpty ?? true)
        ? 'No'
        : widget.item.form.usersTravellingAlong!.join(', ');
  }

  _buildChildrens() {
    final form = widget.item.form;
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
      decoration: MyDecoration.decoration(shadow: false, color: Color.fromARGB(255, 242, 242, 242)),
      padding: kPadding,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.form.question(key),
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
