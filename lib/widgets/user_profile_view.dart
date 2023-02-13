import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/user_profile/user_profile.dart';
import 'package:bioplus/ui/user_profile/widgets/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileWidget extends StatelessWidget {
  final UserData user;
  const UserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kPadding,
      decoration: MyDecoration.decoration(
        shadow: false,
      ).copyWith(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'User Profile',
                style: context.textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: _openProfilePage,
                icon: const Icon(Icons.edit),
              )
            ],
          ),
          Gap(20.h),
          _buildRow(
            Strings.firstName,
            user.firstName ?? '',
            Strings.lastName,
            user.lastName ?? '',
          ),
          Gap(20.h),
          _buildRow(
            Strings.email,
            user.email ?? '',
            Strings.mobile,
            '${user.countryCode ?? ''} ${user.phoneNumber ?? ''}',
          ),
          Gap(20.h),
          _buildRow(
            Strings.emergencyMobileContact,
            user.emergencyEmailContact ?? '',
            Strings.emergencyEmailContact,
            '${user.countryCode ?? ''} ${user.emergencyMobileContact ?? ''}',
          ),
          // Gap(20.h),
          // _buildRow(
          //   Strings.emergencyEmailContact,
          //   user.email ?? '',
          //   Strings.mobile,
          //   user.emergencyEmailContact ?? '',
          // )
        ],
      ),
    );
  }

  Widget _buildRow(String field1, String value1, String field2, String value2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  void _openProfilePage() {
    Get.to(
      () => ChangeNotifierProvider(
        create: (context) => UserProfileNotifier(context),
        child: const EditProfile(),
      ),
    );
  }
}
