import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/user_profile/provider/provider.dart';
import 'package:bioplus/ui/user_profile/widgets/edit_profile.dart';
import 'package:bioplus/widgets/biosecure_logo.dart';
import 'package:flutter/material.dart';

class LardnerFarmWorld extends StatelessWidget {
  const LardnerFarmWorld({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLogo(),
          Gap(3.height),
          Text(
            'Welcome to Lardner Park Farm World. To deliver a safer experience at Farm World we utilise the BIOPLUS® Emergency Warning System to notify our visitors of any incident or accidents on the field day site and deliver instructions to visitors automatically',
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Gap(3.height),
          MyElevatedButton(
            onPressed: () async {
              Get.back();
              Get.to(
                () => ChangeNotifierProvider(
                  create: (context) => UserProfileNotifier(context),
                  child: const EditProfile(),
                ),
              );
            },
            text: 'OK',
          ),
        ],
      ),
    );
  }
}
