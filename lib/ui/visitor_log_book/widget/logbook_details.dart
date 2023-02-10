import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:bioplus/ui/visitor_log_book/view/create_declaration_form_pdf.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/signature/signature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogbookDetails extends StatefulWidget {
  final LogbookEntry item;
  const LogbookDetails({super.key, required this.item});

  @override
  State<LogbookDetails> createState() => _LogbookDetailsState();
}

class _LogbookDetailsState extends State<LogbookDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        elevation: 5,
        title: Text(
          (widget.item.form?.isWarakirriFarm ?? false)
              ? 'Warakirri Entry Form'
              : 'Declaration Form',
        ),
        actions: [
          IconButton(
            onPressed: () {
              final service = FormsStorageService(context.read<Api>());
              final logbookFormPrinter = DeclarationFormPrinter(
                entry: widget.item,
                formsStorageService: service,
              );

              logbookFormPrinter.createPdf();
              // CreatePDf.printDeclarationForm(item);
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
          Gap(20.w),
        ],
        // showDivider: true,
        // backgroundColor: context.theme.primaryColor,
      ),
      body: ListView(
        padding: kPadding,
        children: (widget.item.form?.isWarakirriFarm ?? false)
            ? _buildWarakirriForm()
            : _buildChildrens(),
      ),
    );
  }

  WarakirriQuestionFormModel get warakirriKeys =>
      widget.item.form!.warakirriKeys;
  LogbookFormModel get form => widget.item.form!;

  List<Widget> _buildWarakirriForm() {
    return [
      _userInfo(context),
      _card(warakirriKeys.isPeopleTravelingWith, getNames()),
      _card(warakirriKeys.isFluSymptoms, getValue(form.isFluSymptoms)),
      _card(warakirriKeys.isOverSeaVisit, getValue(form.isOverSeaVisit)),
      _card(warakirriKeys.hasBeenInducted, getValue(form.hasBeenInducted)),
      _card(warakirriKeys.isConfinedSpace, getValue(form.isConfinedSpace)),
      _card(warakirriKeys.additionalInfo, form.additionalInfo),
      _card(warakirriKeys.warakirriFarm, form.warakirriFarm),
    ];
  }

  List<Widget> _buildChildrens() {
    final form = widget.item.form!;
    return [
      _userInfo(context),
      _card(form.keys.isPeopleTravelingWith, form.getVisitorsNames()),
      _card(form.keys.isQfeverVaccinated, getValue(form.isQfeverVaccinated!)),
      _card(form.keys.isFluSymptoms, getValue(form.isFluSymptoms)),
      _card(form.keys.isOverSeaVisit, getValue(form.isOverSeaVisit)),
      _card(form.keys.isAllMeasureTaken, getValue(form.isAllMeasureTaken)),
      _card(form.keys.isOwnerNotified, getValue(form.isOwnerNotified)),
      // _card(
      //   form.keys.expectedDepartureDate,
      //   MyDecoration.formatDateWithTime(form.expectedDepartureDate),
      // ),
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

  Container _card(String key, String? value2) {
    if (value2 == null) return Container();
    return Container(
      decoration: MyDecoration.decoration(
        shadow: false,
        color: const Color.fromARGB(255, 242, 242, 242),
      ),
      padding: kPadding,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.form!.question(key),
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

  Widget _userInfo(BuildContext context) {
    return Container(
      // padding: kPadding,
      margin: kPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entry Details',
            style: context.textTheme.titleLarge,
          ),
          Gap(20.h),
          _buildRow(
            'Full Name',
            widget.item.user?.fullName ?? '',
            'Company Name',
            widget.item.user?.companies ?? '',
          ),
          Gap(20.h),
          _buildRow(
            'Phone Number',
            '${widget.item.user?.countryCode ?? ''} ${widget.item.user?.phoneNumber ?? ''}',
            'Expected Departure Time',
            getDateTime(widget.item.form?.expectedDepartureDate),
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
        const Spacer(),
        Expanded(
          flex: 2,
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
          maxLines: 2,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String? getValue(bool? value) {
    return value == null
        ? null
        : value
            ? 'Yes'
            : 'No';
  }

  String getDateTime(DateTime? dateTime) {
    return '${MyDecoration.formatDate(dateTime)}  ${MyDecoration.formatTime(dateTime)}';
  }

  String getNames() {
    return (widget.item.form?.usersTravellingAlong?.isEmpty ?? true)
        ? 'No'
        : widget.item.form!.usersTravellingAlong!.join(', ');
  }
}
