import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/api_constants.dart';
import 'package:background_location/theme/color_constants.dart';
import 'package:background_location/ui/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const enableCrashlytics = !kDebugMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    final repo = ApiRepo();
    await repo.init(baseUrl: ApiConstants.baseUrl);
    runApp(MyApp(api: repo));
    // runApp(MyApp());
    // if (enableCrashlytics) FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }, (error, stackTrace) {
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  final Api api;
  const MyApp({Key? key, required this.api}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Future<void> _initializeFlutterFire() async {
  //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enableCrashlytics);
  // }

  @override
  void initState() {
    // _initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Api>.value(value: widget.api),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.white,
          // primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: kPrimaryColor,
              ),

          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: null,
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
        ],

        // home: SplashScreen(),
        home: ScreenUtilInit(
          child: SplashScreen(),
          designSize: Get.size,
          builder: (context, child) => SplashScreen(),
        ),
      ),
    );
  }
}
