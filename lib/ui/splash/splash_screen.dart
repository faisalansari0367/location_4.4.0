import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/ui/login/view/login_page.dart';
import 'package:background_location/ui/sign_up/view/sign_up_page.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:local_auth_repo/local_auth.dart';
import 'package:lottie/lottie.dart';

import '../../constants/constans.dart';
import '../select_role/view/select_role_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSplash = true;

  @override
  void initState() {
    final user = context.read<Api>().getUser();
    Future.delayed((kSplashDuration.inMilliseconds - 500).milliseconds, () async {
      if (user == null) return;
      final localAuth = LocalAuth();
      final result = await localAuth.authenticate();
      if (!result) {
        Get.off(() => LoginPage(email: user.email));
      } else {
        Get.off(() => SelectRolePage());
      }
      // Get.off(() => SelectRolePage());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SelectRolePage(),
      //   ),
      // );
    });
    Future.delayed((kSplashDuration.inSeconds - 1).seconds, () {
      if (user != null) return;

      if (!mounted) return;
      setState(() {
        showSplash = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: kPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(10.height),
            Lottie.asset(Assets.animations.welcome),
            Gap(10.height),
            Gap(2.height),
            AnimatedOpacity(
              opacity: showSplash ? 0 : 1,
              duration: 375.milliseconds,
              child: Column(
                children: [
                  Text(
                    '${Strings.welcomeTo} ${Strings.appName}',
                    style: context.textTheme.headline5,
                  ),
                  Gap(5.height),
                  MyElevatedButton(
                    text: (Strings.login),
                    onPressed: () async => Get.to(() => LoginPage()),
                  ),
                  // Gap(2.height),
                  _orSeperator(context),
                  MyElevatedButton(
                    text: (Strings.signUp),
                    onPressed: () async => Get.to(() => SignUpPage()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _orSeperator(
    BuildContext context,
  ) {
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
