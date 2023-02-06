import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/user_profile/provider/provider.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/state_dropdown_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfile extends StatelessWidget {
  final UserData? userData;
  const EditProfile({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final user = userData ?? context.read<UserProfileNotifier>().user;

    return Scaffold(
      appBar: MyAppBar(
        title: Text(Strings.editProfile),
      ),
      body: Padding(
        padding: kPadding,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 5),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                dragStartBehavior: DragStartBehavior.down,
                child: AutoSpacing(
                  spacing: Gap(10.h),
                  children: [
                    MyTextField(
                      hintText: 'First Name',
                      initialValue: user?.firstName ?? '',
                    ),
                    MyTextField(
                      hintText: 'Last Name',
                      initialValue: user?.lastName ?? '',
                    ),
                    EmailField(
                      initialValue: user?.email ?? '',
                    ),
                    PhoneTextField(initialValue: user?.phoneNumber ?? ''),
                    MyTextField(
                      hintText: 'Street',
                      initialValue: user?.street ?? '',
                    ),
                    MyTextField(
                      hintText: 'Town',
                      initialValue: user?.town ?? '',
                    ),
                    MyTextField(
                      hintText: 'City',
                      initialValue: user?.city ?? '',
                    ),
                    StateDropdownField(
                      onChanged: (value) {},
                      value: user?.state ?? '',
                    ),
                    MyTextField(
                      hintText: 'Post Code',
                      initialValue: user?.postcode.toString() ?? '',
                    ),
                    PhoneTextField(
                      hintText: 'Emergency Mobile Contact',
                      initialValue:
                          user?.emergencyMobileContact.toString() ?? '',
                    ),
                    EmailField(
                      label: 'Emergency Mobile Email',
                      initialValue:
                          user?.emergencyEmailContact.toString() ?? '',
                    ),
                  ],
                ),
              ),
            ),
            Gap(10.h),
            const MyElevatedButton(
              text: 'Save',
            ),
          ],
        ),
      ),
    );
  }
}
