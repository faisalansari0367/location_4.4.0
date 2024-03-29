import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/services/notifications/intent_service.dart';
import 'package:bioplus/ui/visitor_check_in/cubit/visitor_check_in_cubit.dart';
import 'package:bioplus/ui/visitor_check_in/view/qr_code_widget.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VisitorCheckInView extends StatelessWidget {
  const VisitorCheckInView({super.key});

  @override
  Widget build(BuildContext context) {
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
                if (state.qrCode != null)
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.width,
                            // strokeAlign: StrokeAlign.outside,
                            
                          ),
                          borderRadius: kBorderRadius,
                        ),
                        child: QRCodeImage(
                          image: state.qrCode!,
                        ),
                      ),
                      Gap(20.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.width,
                          vertical: 10.h,
                        ),
                        child: AutoSizeText(
                          'Scan me',
                          textAlign: TextAlign.center,
                          style: context.textTheme.headline6?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  const CircularProgressIndicator(),
                Gap(20.h),
                _infoCard(context),
              ],
            ),
          );
        },
      ),
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
              borderRadius: BorderRadius.circular(50),
            ),
            child: AutoSizeText(
              'Visitors',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: context.textTheme.headline6?.copyWith(
                color: const Color.fromARGB(255, 255, 255, 255),
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
          SizedBox(
            child: AutoSizeText(
              'Farm Biosecurity'.toUpperCase(),
              maxLines: 1,
              style: context.textTheme.headline6?.copyWith(
                color: const Color.fromARGB(255, 255, 0, 0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(color: Color.fromARGB(255, 0, 0, 0)),
          SizedBox(
            width: double.infinity,
            child: AutoSizeText(
              'Please phone or visit the office before entering',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: context.textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(),
          _phoneNumber(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AutoSizeText(
                  'Do not enter property without prior consent',
                  maxLines: 2,
                  textAlign: TextAlign.center,
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
            'Vehicles, people and equipment can carry weed seeds, pests and diseases',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyText2?.copyWith(
              color: const Color.fromARGB(158, 255, 0, 0),
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(20.h),
          AutoSizeText(
            'Automated Biosecurity Compliance\nPowered by ${Strings.appName}',
            textAlign: TextAlign.center,
            style: context.textTheme.headline6?.copyWith(
              color: context.theme.primaryColor,
              fontSize: 16.w,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<VisitorCheckInCubit, VisitorCheckInState> _phoneNumber() {
    return BlocBuilder<VisitorCheckInCubit, VisitorCheckInState>(
      builder: (context, state) {
        final phoneNumber = context.read<VisitorCheckInCubit>().getPhoneNumber();
        if (phoneNumber.trim().isEmpty) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => IntentService.dialIntent(phoneNumber),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone,
                color: Color.fromARGB(255, 80, 106, 255),
              ),
              Text(
                phoneNumber,
                style: context.textTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: const Color.fromARGB(255, 80, 106, 255),
                  fontSize: 17.w,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
