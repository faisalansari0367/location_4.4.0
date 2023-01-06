import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';
import 'package:bioplus/theme/color_constants.dart';
import 'package:bioplus/ui/maps/location_service/polygons_service.dart';
import 'package:bioplus/ui/sos_warning/sos_warning.dart';
import 'package:bioplus/ui/splash/splash_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';

import 'services/notifications/push_notifications.dart';
import 'ui/login/view/login_page.dart';
import 'ui/maps/location_service/geofence_service.dart';

class MyApp extends StatefulWidget {
  final Api api;
  // final MapsRepo mapsRepo;
  // final CvdFormsRepoImpl cvdFormsRepo;
  // final NotificationService notificationService;
  final PushNotificationService pushNotificationService;
  final LocalApi localApi;

  const MyApp({
    Key? key,
    required this.api,
    // required this.notificationService,
    // required this.mapsRepo,
    required this.pushNotificationService,
    required this.localApi,
    // required this.cvdFormsRepo,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _initializeFlutterFire() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  @override
  void initState() {
    MyConnectivity();
    _loggedInStream();
    _initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _providers,
      child: GetMaterialApp(
        // customTransition,
        defaultTransition: getx.Transition.cupertino,
        // debugShowCheckedModeBanner: ApiConstants.isDegugMode,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: GoogleFonts.nunito().fontFamily,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: kPrimaryColor),
          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // appBarTheme: AppBarTheme(
          // titleTextStyle: TextStyle(
          //   // color: Colors.black,
          //   fontFamily: GoogleFonts.
          //   // fontSize: 20.sp,
          //   // fontWeight: FontWeight.w600,
          // ),
          // ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            checkColor: MaterialStateProperty.all(Colors.white),
            fillColor: MaterialStateProperty.all(kPrimaryColor),
          ),
        ),
        home: LayoutBuilder(
          builder: (context, constraints) => ScreenUtilInit(
            designSize: Size(constraints.maxWidth, constraints.maxHeight),
            // designSize: Size(1179, 2556),
            builder: (context, child) => const SplashScreen(),
            child: const SplashScreen(),
          ),
        ),
      ),
    );
  }

  List<RepositoryProvider> get _providers {
    return [
      RepositoryProvider<Api>.value(value: widget.api),
      // RepositoryProvider<NotificationService>.value(value: widget.notificationService),
      RepositoryProvider<PushNotificationService>.value(value: widget.pushNotificationService),
      // RepositoryProvider<MapsRepo>.value(value: widget.mapsRepo),
      RepositoryProvider<LocalApi>.value(value: widget.localApi),
      RepositoryProvider<PolygonsService>(create: (context) => PolygonsService()),
      // RepositoryProvider<MapsRepoLocal>(create: (context) => MapsRepoLocal()..init()),
      RepositoryProvider<GeofenceService>(create: (context) => GeofenceService()),
      // RepositoryProvider<GeofenceService>(create: (context) => GeofenceService()),
      // RepositoryProvider<CvdFormsRepo>.value(
      //   value: widget.cvdFormsRepo,
      // ),
    ];
  }

  void _loggedInStream() {
    widget.api.isLoggedInStream.listen((event) async {
      final isLoggedIn = event;
      print('isLoggedIn $isLoggedIn');
      if (!isLoggedIn) return Get.off(() => LoginPage());
      // final user = widget.api.getUser()!;
      // final localAuth = LocalAuth();
      // final result = await localAuth.authenticate();
      // if (!result) {
      //   await Get.offAll(() => LoginPage(email: user.email));
      // } else {
      //   Get.offAll(() => const DrawerPage());
      //   Get.to(() => MapsPage());
      // }
    });
  }
}
