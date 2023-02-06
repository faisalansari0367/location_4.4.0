import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/features/drawer/view/drawer_page.dart';
import 'package:bioplus/ui/login/view/login_page.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/ui/sign_up/view/sign_up_page.dart';
import 'package:bioplus/widgets/logo/app_name_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_repo/local_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSplash = true;

  @override
  void initState() {
    final api = context.read<Api>();
    // final notificationService = context.read<PushNotificationService>();
    api.isLoggedInStream.listen((event) async {
      if (!mounted) return;
      final isLoggedIn = event;
      log('isLoggedIn $isLoggedIn');
      if (!isLoggedIn) return Get.off(() => const LoginPage());
      final user = context.read<Api>().getUser()!;
      final localAuth = LocalAuth();
      final result = await localAuth.authenticate();
      if (!result) {
        await Get.offAll(() => LoginPage(email: user.email));
      } else {
        // await _init();
        Get.offAll(() => const DrawerPage());
        Get.to(() => const MapsPage());
      }
    });
    final duration = (kSplashDuration.inMilliseconds - 1000).milliseconds;
    Future.delayed(duration, () async {
      // Get.offAll(() => NewSplashScreen());
      if (!mounted) return;
      final isLoggedIn = api.isLoggedIn;

      if (!isLoggedIn) return Get.off(() => const LoginPage());
      final user = context.read<Api>().getUser()!;
      if (kDebugMode) {
        Get.offAll(() => const DrawerPage());
        Get.to(() => const MapsPage());
        return;
      }
      final localAuth = LocalAuth();
      final result = await localAuth.authenticate();
      if (!result) {
        await Get.offAll(() => LoginPage(email: user.email));
      } else {
        // await _init();
        Get.offAll(() => const DrawerPage());
        Get.to(() => const MapsPage());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final size = 13.width;

    return Scaffold(
      backgroundColor:
          ApiConstants.isDegugMode ? Colors.black87 : const Color(0XFF79C351),
      body: SingleChildScrollView(
        padding: kPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(15.height),
            Center(
              child: Image.asset(
                'assets/icons/BIOPLUS LOGO - Blue & White 2.png',
                fit: BoxFit.fitHeight,
                // alignment: Alignment.center,
                height: 70.width,
                // width: 100.width,
                // scale: 0.1,
              ),
            ),
            // Gap(10.height),
            Gap(2.height),
            // AppName(

            // ),
            // Center(
            //   child: AutoSizeText.rich(
            //     TextSpan(
            //       children: [
            //         TextSpan(
            //           text: 'BIO',
            //           style: TextStyle(
            //             color: const Color(0xff3B4798),
            //             fontWeight: FontWeight.bold,
            //             fontSize: size,
            //           ),
            //         ),
            //         TextSpan(
            //           text: 'PLUS',
            //           style: TextStyle(
            //             color: Color.fromARGB(255, 255, 255, 255),
            //             // fontWeight: FontWeight.w500,
            //             fontSize: size,
            //           ),
            //         ),
            //       ],
            //       style: context.textTheme.headline5,
            //     ),
            //     textAlign: TextAlign.center,
            //     maxLines: 1,
            //   ),
            // ),
            AnimatedOpacity(
              opacity: showSplash ? 0 : 1,
              duration: 375.milliseconds,
              child: Column(
                children: [
                  Gap(10.height),

                  const AppName(),
                  Gap(2.height),

                  MyElevatedButton(
                    text: Strings.login,
                    onPressed: () async => Get.off(() => const LoginPage()),
                  ),
                  // Gap(2.height),
                  _orSeperator(context),
                  MyElevatedButton(
                    text: Strings.signUp,
                    onPressed: () async => Get.to(() => const SignUpPage()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _orSeperator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.height),
      child: Row(
        children: [
          _divider(context),
          const Text('OR'),
          _divider(context),
        ],
      ),
    );
  }

  Expanded _divider(BuildContext context) {
    return Expanded(
      child: Divider(
        indent: 5.width,
        endIndent: 5.width,
        color: context.theme.iconTheme.color,
        // thickness: 2.height,
      ),
    );
  }
}
