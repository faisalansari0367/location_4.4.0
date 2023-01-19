import 'dart:io';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/features/bottom_navbar/cubit/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_expense_trackr/constans.dart';
// import 'package:flutter_expense_trackr/extensions/theme_extension.dart';
// import 'package:flutter_expense_trackr/widgets/index.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class NavbarView extends StatelessWidget {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.backgroundColor;
    final tabBackgroundColor = context.theme.brightness != Brightness.light
        ? context.theme.backgroundColor
        : const Color.fromARGB(255, 255, 255, 255);

    return BlocBuilder<NavbarCubit, NavbarState>(
      builder: (context, state) {
        return Scaffold(
          body: PageTransitionSwitcher(
            duration: kDuration,
            reverse: state.reverse,
            transitionBuilder: transitionBuilder,
            child: context.read<NavbarCubit>().currentPage,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(kInputRadius),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  color: context.theme.iconTheme.color!.withOpacity(.40),
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            margin: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: Platform.isAndroid ? 12 : min(MediaQuery.of(context).viewPadding.bottom, 2.5.height),
            ),
            // margin: kMargin,
            padding: kMargin,
            child: GNav(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              backgroundColor: context.theme.backgroundColor,
              onTabChange: context.read<NavbarCubit>().updateIndex,
              tabActiveBorder: Border.all(),
              gap: 2.width,
              tabBackgroundColor: tabBackgroundColor,
              color: const Color.fromARGB(255, 120, 120, 120),
              // color: tabBackgroundColor,

              activeColor: context.theme.iconTheme.color,
              rippleColor: tabBackgroundColor,
              iconSize: 6.width,
              padding: kMargin,
              textStyle: context.textTheme.bodyText2
                  ?.copyWith(color: const Color.fromARGB(255, 36, 36, 36), fontWeight: FontWeight.w600),
              tabs: tabs(),
            ),
          ),
        );
      },
    );
  }

  Widget transitionBuilder(
    Widget child,
    Animation<double> primaryAnimation,
    Animation<double> secondaryAnimation,
  ) {
    return SharedAxisTransition(
      fillColor: Colors.transparent,
      animation: primaryAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      child: child,
    );
  }

  List<GButton> tabs() {
    // return const [
    //   GButton(icon: LineIcons.alternateCreativeCommonsPublicDomain, text: 'Admin'),
    //   GButton(icon: LineIcons.userAlt, text: 'Select Role'),
    //   GButton(icon: LineIcons.maptext: 'Maps'),
    //   GButton(icon: LineIcons.userCog, text: 'Settings'),
    // ];

    return const [
      GButton(icon: Icons.dashboard, text: Strings.dashboard),
      GButton(icon: LineIcons.qrcode, text: 'Scan Code'),
      GButton(icon: LineIcons.userAlt, text: '${Strings.select} ${Strings.role}'),
      // GButton(icon: LineIcons.map, text: 'Maps'),
      GButton(icon: LineIcons.userCog, text: Strings.settings),
    ];
  }
}
