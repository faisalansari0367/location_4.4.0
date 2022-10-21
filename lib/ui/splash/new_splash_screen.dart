import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/ui/login/view/login_page.dart';
import 'package:background_location/ui/sign_up/view/sign_up_page.dart';
import 'package:background_location/widgets/animations/my_slide_animation.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../constants/constans.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({Key? key}) : super(key: key);

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen> {
  bool showSplash = true;

  @override
  void initState() {
    final isLoggedIn = context.read<Api>().isLoggedIn;

    // Future.delayed((kSplashDuration.inMilliseconds - 1000).milliseconds, () async {
    //   if (!isLoggedIn) return;
    //   final user = context.read<Api>().getUser()!;
    //   final localAuth = LocalAuth();
    //   final result = await localAuth.authenticate();
    //   if (!result) {
    //     await Get.off(() => LoginPage(email: user.email));
    //   } else {
    //     await Get.off(() => const DrawerPage());
    //   }
    // });
    // Future.delayed((kSplashDuration.inSeconds - 0.5).seconds, () {
    //   if (!mounted) return;
    //   setState(() {
    //     showSplash = false;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = 13.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: kPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(10.height),
            MySlideAnimation(
              child: FadeInAnimation(
                duration: kDuration,
                child: Center(
                  child: Image.asset(
                    Assets.icons.appIcon.path,
                    fit: BoxFit.fitHeight,
                    // alignment: Alignment.center,
                    height: 70.width,
                    // width: 100.width,
                    // scale: 0.1,
                  ),
                ),
              ),
            ),
            // Gap(10.height),
            Gap(2.height),
            AnimatedOpacity(
              opacity: showSplash ? 0 : 1,
              duration: 375.milliseconds,
              child: Column(
                children: [
                  Gap(10.height),
                  // RichText(
                  //   text: TextSpan(
                  //     // text: Strings.welcomeTo,
                  //     children: [
                  //       TextSpan(
                  //         text: ' BIO',
                  //         style: TextStyle(
                  //           color: Color(0xff3B4798),
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 60.w,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: 'SECURE',
                  //         style: TextStyle(
                  //           color: Color(0xff75B950),
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 60.w,
                  //         ),
                  //       ),
                  //     ],
                  //     style: context.textTheme.headline5,
                  //   ),
                  // ),
                  // BioSecureLogo(),
                  // const AppName(),
                  AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'BIO',
                          style: TextStyle(
                            color: const Color(0xff3B4798),
                            fontWeight: FontWeight.bold,
                            fontSize: size,
                          ),
                        ),
                        TextSpan(
                          text: 'PLUS',
                          style: TextStyle(
                            color: const Color(0xff75B950),
                            fontWeight: FontWeight.bold,
                            fontSize: size,
                          ),
                        ),
                      ],
                      style: context.textTheme.headline5,
                    ),
                    maxLines: 1,
                  ),
                  Gap(2.height),

                  // Gap(15.height),
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
