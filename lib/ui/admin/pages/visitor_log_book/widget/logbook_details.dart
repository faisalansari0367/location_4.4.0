import 'package:api_repo/api_repo.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/my_radio_button.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../constants/index.dart';

class LogbookDetails extends StatelessWidget {
  final List<LogbookFormField> form;
  const LogbookDetails({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Log details'),
        // showDivider: true,
        // backgroundColor: context.theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: kPadding,
        child: Column(
          // children: [for (var item in form) getWidget(item)],
          children: cardChildren(form),
        ),
      ),
    );
  }

  List<Widget> cardChildren(List<LogbookFormField> form) {
    final children = <Widget>[];
    for (final item in form) {
      children.add(getWidget(item));
      // children.add(Gap(10.h));
      children.add(
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
      );
    }
    return children;
  }

  List<Widget> childrens(dynamic form) {
    final list = <Widget>[];
    if (form == null) return list;
    if (form is! Map) list;
    if (form is Map) {
      list.add(const Divider());
      list.add(_headerRow());
      list.add(const Divider());
      form.forEach((key, value) {
        list.add(_radioButton(key, value));
        list.add(const Divider());
      });
    }
    return list;
  }

  // List<Widget> cardChildrens(List<LogbookFormField> form) {
  //   final list = <Widget>[];
  //   // if (form == null) return list;
  //   // if (form is! Map) list;
  //   // if (form is Map) {
  //   // list.add(Divider());
  //   // list.add(_headerRow());
  //   // list.add(Divider());
  //   form.forEach((element) {
  //     list.add(getWidget(element));
  //     // list.add(Divider());
  //   });
  //   // }
  //   return list;
  // }

  List<TableRow> _tableChildrens(dynamic form) {
    final textStyle = TextStyle(
      color: Colors.grey.shade700,
      fontSize: 19.w,
      fontWeight: FontWeight.w900,
    );
    final list = <TableRow>[];
    if (form == null) return list;
    if (form is! Map) list;
    if (form is Map) {
      // list.add(Divider());
      // list.add(_headerRow());
      // list.add(Divider());
      form.forEach((key, value) {
        final row = TableRow(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          children: [
            Text(
              key,
              style: textStyle.copyWith(
                fontSize: 16.w,
              ),
              // textAlign: TextAlign.center,
            ),
            Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ],
        );
        list.add(row);
        // list.add(_radioButton(key, value));
        // list.add(Divider());
      });
    }
    return list;
  }

  Widget getWidget(LogbookFormField field) {
    switch (field.field!.toLowerCase()) {
      case 'signature:':
      case 'signature':
        return SignatureWidget(
          signature: field.value,
        );

      case 'day/date/time':
        return _qna(field.field!, MyDecoration.formatDateTime(DateTime.tryParse(field.value!)));
      case 'time':
      case 'expected departure time':
        return _qna(field.field!, MyDecoration.formatTime(DateTime.tryParse(field.value!)));
      case 'date':
      case 'expected departure date':
        return _qna(field.field!, MyDecoration.formatDate(DateTime.tryParse(field.value!)));
      default:
        if (field.value is List) {
          return _qna(field.field!, field.value.join(', '));
        }
        return _qna(field.field!, field.value!);
    }
  }

  Widget _rowLayout({required Widget text, required Widget option1, required Widget option2}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: text,
        ),
        Expanded(
          child: option1,
        ),
        Expanded(
          child: option2,
        ),
      ],
    );
  }

  Widget _headerRow() {
    final textStyle = TextStyle(
      color: Colors.grey.shade900,
      fontSize: 19.w,
      fontWeight: FontWeight.w900,
    );
    return _rowLayout(
      text: Text(
        'Question',
        style: textStyle,
        // textAlign: TextAlign.center,
      ),
      option1: Text(
        'Yes',
        textAlign: TextAlign.center,
        style: textStyle,
      ),
      option2: Text(
        'No',
        textAlign: TextAlign.center,
        style: textStyle,
      ),
    );
  }

  Widget _radioButton(String question, bool answer) {
    return SizedBox(
      width: 100.width,
      child: _rowLayout(
        text: Text(
          question.trim(),
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 16.w,
          ),
        ),
        option1: MyRadioButton(value: true, selectedValue: answer),
        option2: MyRadioButton(value: false, selectedValue: answer),
      ),
    );
  }

  Widget _qna(String question, String answer) {
    return Container(
      width: 100.width,
      // padding: kPadding.copyWith(bottom: 0),
      // margin: EdgeInsets.symmetric(vertical: 10.h),
      // decoration: MyDecoration.decoration(color: Color.fromARGB(255, 255, 255, 255)),
      decoration: const BoxDecoration(
        // color: Colors.grey.shade100,
        // color: backgroundColor,
        borderRadius: kBorderRadius,
      ),
      // margin: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          // Positioned(
          //   top: 20.h,
          //   right: 20.w,
          //   child: Opacity(
          //     opacity: 0.1,
          //     child: Image.asset(
          //       'assets/images/qa.png',
          //       height: 100,
          //     ),
          //   ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // headline text style
              // Text(
              //   question,
              //   style: TextStyle(
              //     color: Colors.grey.shade900,
              //     fontSize: 19.w,
              //     fontWeight: FontWeight.w900,
              //   ),
              // ),
              Text(
                question.trim(),
                style: TextStyle(
                  // color: Colors.grey.shade700,
                  // // color: textColor,
                  // fontWeight: FontWeight.w600,
                  // fontSize: 16.w,
                  color: Colors.grey.shade900,
                  fontSize: 19.w,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Gap(5.h),

              // answer text style ̏ ̏ ̏ ̏ ̏ ̏
              Text(
                answer.trim(),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  // color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.w,
                ),
              ),
              // Gap(15.h),
            ],
          ),
        ],
      ),
    );
  }

  bool? selectedValue(String? value) => value == null
      ? null
      : value.toLowerCase() == 'yes'
          ? true
          : null;

  Widget _table(form) {
    final textStyle = TextStyle(
      color: Colors.grey.shade900,
      fontSize: 19.w,
      fontWeight: FontWeight.w900,
    );
    return Table(
      // columnWidths: {1, TableColumnWidth()},

      border: TableBorder.all(
        color: Colors.grey.shade400,
      ),
      children: [
        _tableHead(textStyle),
        ..._tableChildrens(form),
      ],
    );
  }

  TableRow _tableHead(TextStyle textStyle) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      children: [
        Text(
          'Question',
          style: textStyle,
          // textAlign: TextAlign.center,
        ),
        Text(
          'Ans',
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ],
    );
  }
}
