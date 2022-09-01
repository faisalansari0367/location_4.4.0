import 'package:background_location/constants/index.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class VisitorCheckIn extends StatelessWidget {
  const VisitorCheckIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Strings.visitorCheckIn),
        showDivider: true,
      ),
      body: SingleChildScrollView(
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
                      fontSize: 25.h,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Gap(10.h),
                  SizedBox(
                    width: 60.width,
                    height: 60.width,
                    child: Container(
                      // color: Colors.white,
                      decoration: MyDecoration.decoration(),
                      child: Image.asset(
                        'assets/images/QR_code_for_mobile_English_Wikipedia.png',
                        // width: 60.width,
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
      ),
    );
  }

  Container _infoCard(BuildContext context) {
    return Container(
      padding: kPadding,
      // decoration: BoxDecoration(
      //   color: Color.fromARGB(0, 255, 75, 75),
      //   borderRadius: kBorderRadius,
      // ),
      decoration: MyDecoration.decoration().copyWith(
          // // color: context.theme.primaryColor,
          border: Border.all(color: Colors.red, width: 1.width)
          // boxShadow: [
          //   BoxShadow(
          //     color: context.theme.primaryColor,
          //     blurRadius: 40,
          //   ),
          // ],
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
                fontSize: 40.h,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(10.h),
          Text(
            'Please respect',
            style: context.textTheme.headline6?.copyWith(
              // color: Colors.white,
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

          // Gap(15.h),
          Text(
            'Please phone or visit the office before entering',
            style: context.textTheme.subtitle1?.copyWith(
              // color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone),
              Gap(5.w),
              Text(
                '+61 234234234',
                style: context.textTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Divider(),
          // Gap(15.h),
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
