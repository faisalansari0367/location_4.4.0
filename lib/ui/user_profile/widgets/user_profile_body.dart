import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/PIC/view/pic_page.dart';
import 'package:bioplus/ui/geofence_delegation/geofence_delegation.dart';
import 'package:bioplus/ui/user_profile/provider/provider.dart';
import 'package:bioplus/ui/user_profile/widgets/edit_profile.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/image/my_network_image.dart';
import 'package:bioplus/widgets/profile/role_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// {@template user_profile_body}
/// Body of the UserProfilePage.
///
/// Add what it does
/// {@endtemplate}
class UserProfileBody extends StatelessWidget {
  /// {@macro user_profile_body}
  const UserProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,

          // fontSize: 24.sp,
        );

    return Consumer<UserProfileNotifier>(
      builder: (context, state, child) {
        return ListView(
          padding: kPadding.copyWith(top: 0),
          children: [
            // UserAccountsDrawerHeader(
            //   accountName: Text(state.user?.fullName ?? 'User'),
            //   accountEmail: Text(state.user?.email ?? ''),
            //   currentAccountPicture: const FlutterLogo(),
            // ),
            _profileSection(context, state),
            // const Divider(
            //   height: 0,
            //   thickness: 2,
            // ),

            // const Text(
            //   'Account',
            //   style: TextStyle(
            //     // color: Colors.white,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 24,
            //   ),
            // ),

            _accountTiles(state, context),
            _buildTile(
              Strings.logout,
              icon: Icons.logout,
              onTap: () {
                state.logout(context);
              },
            ),
            // const Divider(
            //   height: 0,
            //   thickness: 2,
            // ),

            _tiles(),

            Gap(20.h),
          ],
        );
      },
    );
  }

  Widget _accountTiles(UserProfileNotifier provider, BuildContext context) {
    return AutoSpacing(
      spacing: const Divider(
        height: 0,
      ),
      children: [
        _buildTile(
          Strings.editProfile,
          icon: Icons.edit,
          onTap: () => to(
            ChangeNotifierProvider.value(
              value: provider,
              child: EditProfile(
                userData: provider.user,
              ),
            ),
          ),
        ),
        _buildTile(
          Strings.pic,
          icon: Icons.change_history_rounded,
          onTap: () {
            to(const PicPage());
          },
        ),
        if (provider.showGeofenceDelegation)
          _buildTile(
            Strings.geofenceDelegation,
            icon: Icons.location_on,
            onTap: () => to(const GeofenceDelegationPage()),
          ),
        _buildTile(
          Strings.deleteYourAccount,
          icon: Icons.delete_forever_rounded,
          onTap: () => provider.deleteAccount(context),
        ),
      ],
    );
  }

  Widget _tiles() {
    return const AutoSpacing(
      spacing: Divider(
        height: 0,
      ),
      children: [
        // _buildTile(
        //   Strings.about,
        //   icon: Icons.info,
        //   onTap: () {},
        // ),
        // _buildTile(
        //   Strings.termsAndConditions,
        //   icon: Icons.policy,
        //   onTap: () {},
        // ),
        // // _buildTile(
        // //   Strings.geofenceDelegation,
        // //   icon: Icons.location_on,
        // //   onTap: () {},
        // // ),
        // _buildTile(
        //   Strings.privacyPolicy,
        //   path: 'assets/icons/privacy_policy.png',
        //   icon: Icons.privacy_tip,
        //   onTap: () {},
        // ),
        // _buildTile(
        //   Strings.deleteYourAccount,
        //   icon: Icons.delete_forever_rounded,
        //   onTap: () {},
        // ),
      ],
    );
  }

  Container _profileSection(BuildContext context, UserProfileNotifier state) {
    return Container(
      padding: kPadding,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.grey.shade100,

              // border: Border.all(color: Colors.grey.shade200),
            ),
            child: _userProfile(state.user.logo),
          ),
          Gap(15.h),
          RoleTag(
            bgColor: context.theme.primaryColor,
          ),
          Gap(5.h),
          StreamBuilder<UserData?>(
            stream: state.api.userDataStream,
            builder: (context, snapshot) {
              return Text(
                snapshot.data?.fullName ?? 'User',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              );
            },
          ),
          // Gap(5.h),
          Text(
            state.user.email ?? '',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userProfile(String? logo) {
    if (logo != null && logo.isNotEmpty) {
      return MyNetworkImage(
        urlToImage: logo,
        height: 100,
        width: 100,
      );
    }

    return const Icon(
      Icons.person_outline_sharp,
      size: 100,
    );
  }

  Widget _buildTile(
    String text, {
    VoidCallback? onTap,
    IconData? icon,
    String? path,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        // height: 40,
        // width: 40,
        // alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          // color: Colors.grey.shade100,
          borderRadius: kBorderRadius,
        ),
        child: _buildIcon(icon, path: path),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade100,
        ),
        child: const Icon(Icons.chevron_right_outlined),
      ),
      minLeadingWidth: 25,
      title: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade900,
          fontWeight: FontWeight.w600,
          fontSize: 15.sp,
          letterSpacing: 1.1,
        ),
      ),
      dense: false,
      onTap: onTap,
    );
  }

  Widget _buildIcon(IconData? icon, {String? path}) {
    if (path != null) {
      return Image.asset(
        path,
        width: 25,
        color: Colors.grey.shade800,
      );
    }

    return Icon(
      icon,
      color: Colors.grey.shade800,
    );
  }

  void to(Widget page) => Get.to(() => page);
}
