import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfo extends StatelessWidget {
  final UserData user;
  final DateTime? expectedDepartureTime;
  const UserInfo({super.key, required this.user, required this.expectedDepartureTime});

  @override
  Widget build(BuildContext context) {
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
            user.fullName,
            'Company Name',
            user.company ?? '',
          ),
          Gap(20.h),
          _buildRow(
            'Phone Number',
            '${user.countryCode} ${user.phoneNumber}',
            'Expected Departure Time',
            MyDecoration.formatDateWithTime(expectedDepartureTime),
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
}
