import 'package:background_location/constants/index.dart';
import 'package:background_location/services/notifications/intent_service.dart';
import 'package:background_location/ui/visitor_check_in/cubit/visitor_check_in_cubit.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VisitorCheckInView extends StatelessWidget {
  const VisitorCheckInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VisitorCheckInCubit>();
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Strings.visitorCheckIn),
        showDivider: true,
      ),
      body: BlocBuilder<VisitorCheckInCubit, VisitorCheckInState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: kPadding,
            child: Column(
              children: [
                _infoCard(context),
                Gap(20.h),
                Container(
                  // color: Colors.black,
                  // width: 100.width,
                  // decoration: MyDecoration.decoration(color: Colors.white),
                  child: Column(
                    children: [
                      Gap(20.h),
                      Text(
                        'Scan the Entry Gate QR',
                        style: context.textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 25.w,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Gap(10.h),
                      SizedBox(
                        width: 60.width,
                        height: 60.width,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 7.w,
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: kDuration,
                            child: _qrCode(state),
                          ),
                        ),
                      ),
                      Gap(10.h),
                      Text(
                        'Scan me',
                        style: context.textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 25.h,
                        ),
                      ),
                      Gap(20.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _qrCode(VisitorCheckInState state) {
    return QrImage(
      data: 'App store link and playstore link is coming soon...',
    );
  }

  Column _errorWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Icon(
            Icons.error,
            color: Colors.red,
            size: 40.w,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text(
            'Something went wrong',
            textAlign: TextAlign.center,
            style: context.textTheme.headline6,
          ),
        )
      ],
    );
  }

  Container _infoCard(BuildContext context) {
    return Container(
      padding: kPadding,
      decoration: MyDecoration.decoration().copyWith(
        border: Border.all(color: Colors.red, width: 1.width),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.width, vertical: 5.h),
            decoration: MyDecoration.decoration(color: Colors.red).copyWith(
              // shape: StadiumBorder(),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              Strings.visitor + 's',
              style: context.textTheme.headline6?.copyWith(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 40.w,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(10.h),
          Text(
            'Please respect',
            style: context.textTheme.headline6?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Farm Biosecurity'.toUpperCase(),
            style: context.textTheme.headline6?.copyWith(
              color: Color.fromARGB(255, 255, 0, 0),
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          Text(
            'Please phone or visit the office before entering',
            style: context.textTheme.subtitle1?.copyWith(
              // color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(),
          BlocBuilder<VisitorCheckInCubit, VisitorCheckInState>(
            builder: (context, state) {
              final phoneNumber = context.read<VisitorCheckInCubit>().getPhoneNumber();
              return GestureDetector(
                onTap: () => IntentService.dialIntent(phoneNumber),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 80, 106, 255),
                    ),
                    // Gap(5.w),
                    Text(
                      phoneNumber,
                      style: context.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        // color: Color.fromARGB(255, 33, 65, 243),
                        color: Color.fromARGB(255, 80, 106, 255),

                        fontSize: 17.w,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: Colors.red),
              Gap(5.w),
              Expanded(
                child: Text(
                  "Don't enter property without prior approval",
                  style: context.textTheme.bodyText2?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.w,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey.shade300),
          Text(
            "Vehicles, people and equipment can carry weed seeds, pests and diseases",
            textAlign: TextAlign.center,
            style: context.textTheme.bodyText2?.copyWith(
              color: Color.fromARGB(158, 255, 0, 0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
