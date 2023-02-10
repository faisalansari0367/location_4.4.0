import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/models/enum/field_type.dart';
import 'package:bioplus/ui/user_profile/provider/provider.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfile extends StatelessWidget {
  final UserData? userData;
  const EditProfile({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final user = userData ?? context.read<UserProfileNotifier>().user;
    final state = context.read<UserProfileNotifier>();

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
                      hintText: FieldType.firstName.label,
                      initialValue: user?.firstName ?? '',
                      onChanged: state.onFirstNameChanged,
                    ),
                    MyTextField(
                      hintText: 'Last Name',
                      initialValue: user?.lastName ?? '',
                      onChanged: state.onLastNameChanged,
                    ),
                    EmailField(
                      initialValue: user?.email ?? '',
                      onChanged: state.onEmailChanged,
                    ),
                    PhoneTextField(
                      initialValue: user?.phoneNumber ?? '',
                      onChanged: (number, _) =>
                          state.onPhoneNumberChanged(number),
                    ),
                    // MyTextField(
                    //   hintText: 'Street',
                    //   initialValue: user?.street ?? '',
                    // ),
                    // MyTextField(
                    //   hintText: 'Town',
                    //   initialValue: user?.town ?? '',
                    // ),
                    // MyTextField(
                    //   hintText: 'City',
                    //   initialValue: user?.city ?? '',
                    // ),
                    // StateDropdownField(
                    //   onChanged: (value) {},
                    //   value: user?.state ?? '',
                    // ),
                    // MyTextField(
                    //   hintText: 'Post Code',
                    //   initialValue: user?.postcode.toString() ?? '',

                    // ),
                    PhoneTextField(
                      hintText: 'Emergency Mobile Contact',
                      initialValue:
                          user?.emergencyMobileContact.toString() ?? '',
                      onChanged: (number, countryCode) =>
                          state.onPhoneNumberChanged(number),
                    ),
                    EmailField(
                      label: 'Emergency Mobile Email',
                      initialValue:
                          user?.emergencyEmailContact.toString() ?? '',
                      onChanged: state.onEmergencyEmailChanged,
                    ),
                  ],
                ),
              ),
            ),
            Gap(10.h),
            MyElevatedButton(
              text: 'Save',
              onPressed: state.updateUser,
            ),
          ],
        ),
      ),
    );
  }
}
