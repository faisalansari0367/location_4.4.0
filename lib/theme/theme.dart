import 'package:bioplus/theme/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:google_fonts/google_fonts.dart';

// Our light/Primary Theme

class MyTheme {

  static ThemeData get light {
    const iconThemeData = IconThemeData(color: kAccentIconDarkColor);
    return ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.grey.shade800, fontSize: 19),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        secondary: kSecondaryLightColor,
        brightness: Brightness.dark,
      ),
      cardColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme().copyWith(
        fillColor: kAccentIconLightColor,
      ),
      snackBarTheme: const SnackBarThemeData().copyWith(
        backgroundColor: Colors.white,
      ),
      tabBarTheme: tabbarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
      ),
      iconTheme: iconThemeData,
      primaryIconTheme: iconThemeData,
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        subtitle2: ThemeData.light()
            .textTheme
            .subtitle2
            ?.copyWith(color: Colors.grey.shade600),
      ),
    );
  }

  static ThemeData get dark {
    const backgroundColor = Color(0xFF0D0C0E);
    const iconTheme = IconThemeData(color: kBodyTextColorDark);
    return ThemeData.dark().copyWith(
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.grey.shade200, fontSize: 19),
        color: Colors.transparent,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarIconBrightness: Brightness.dark,
        //   statusBarBrightness: Brightness.dark,
        //   systemNavigationBarContrastEnforced: true,
        //   systemNavigationBarDividerColor: Color.fromARGB(255, 0, 0, 0),
        //   statusBarColor: Color.fromARGB(255, 211, 28, 28),
        //   systemStatusBarContrastEnforced: true,
        //   systemNavigationBarColor: Color.fromARGB(95, 255, 255, 255),
        //   systemNavigationBarIconBrightness: Brightness.dark,
        // ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: backgroundColor,
      cardColor: kSurfaceDarkColor,
      inputDecorationTheme: const InputDecorationTheme().copyWith(
        fillColor: kSurfaceDarkColor,
      ),
      iconTheme: iconTheme,
      primaryIconTheme: iconTheme,
      textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme).copyWith(
          subtitle2: ThemeData.dark()
              .textTheme
              .subtitle2
              ?.copyWith(color: Colors.grey.shade500),),
      colorScheme: const ColorScheme.dark().copyWith(
        // secondary: kSecon,
        secondary: kAccentDarkColor,
        surface: kSurfaceDarkColor,
        brightness: Brightness.light,
      ),
      tabBarTheme:
          tabbarTheme(labelColor: Colors.grey.shade100, unselectedLabelColor: Colors.grey.shade500),
    );
  }

  static TabBarTheme tabbarTheme({required Color labelColor, required Color unselectedLabelColor}) {
    return TabBarTheme(
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kPrimaryColor,
            width: 2,
          ),
        ),
      ),
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
    );
  }


  // static SystemUiOverlayStyle _overlayStyle() {
  //   return SystemUiOverlayStyle(
  //     statusBarIconBrightness: Brightness.light,
  //     statusBarBrightness: Brightness.light,
  //     systemNavigationBarDividerColor: Color.fromARGB(255, 255, 255, 255),
  //     statusBarColor: Color.fromARGB(255, 255, 255, 255),
  //     // systemStatusBarContrastEnforced: true,
  //     systemNavigationBarColor: Color.fromARGB(95, 255, 255, 255),

  //     // systemNavigationBarContrastEnforced: true,
  //     // systemStatusBarContrastEnforced: true,
  //     systemNavigationBarIconBrightness: Brightness.light,
  //   );
  // }
}

// Dark Them


