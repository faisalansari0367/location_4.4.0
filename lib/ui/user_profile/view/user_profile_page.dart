import 'package:bioplus/constants/strings.dart';
import 'package:bioplus/ui/user_profile/provider/provider.dart';
import 'package:bioplus/ui/user_profile/widgets/user_profile_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

/// {@template user_profile_page}
/// A description for UserProfilePage
/// {@endtemplate}
class UserProfilePage extends StatelessWidget {
  /// {@macro user_profile_page}
  const UserProfilePage({super.key});

  /// The static route for UserProfilePage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const UserProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileNotifier(context),
      child: const Scaffold(
        appBar: MyAppBar(
          // centreTitle: true,
          showBackButton: false,
          title: Text(Strings.profile),
        ),
        body: UserProfileView(),
      ),
    );
  }
}

/// {@template user_profile_view}
/// Displays the Body of UserProfileView
/// {@endtemplate}
class UserProfileView extends StatelessWidget {
  /// {@macro user_profile_view}
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserProfileBody();
  }
}
