import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/configs/client.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/theme/color_constants.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_notification/local_notification.dart';
import 'package:path_provider/path_provider.dart';

import 'ui/maps/location_service/maps_api.dart';

const enableCrashlytics = !kDebugMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(() async {
    // await Firebase.initializeApp();
    final repo = ApiRepo();
    final notifications = AwesomeNotifications();
    await repo.init(baseUrl: ApiConstants.baseUrl);
    final mapsRepo = MapsApi(client: Client(baseUrl: ApiConstants.baseUrl, token: repo.getToken()));
    // final mapsRepo = MapsRepoLocal();
    // await mapsRepo.init();
    await notifications.initialize(
      'resource://drawable/logo',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color.fromARGB(255, 0, 0, 0),
          ledColor: Colors.white,
        )
      ],
      debug: true,
    );
    final localNotification = NotificationService(
      channelKey: 'basic_channel',
      channelName: 'basic_channel',
      notifications: notifications,
      appName: Strings.appName,
    );

    final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );

    HydratedBlocOverrides.runZoned(
      () => runApp(MyApp(
        api: repo,
        notificationService: localNotification,
        mapsRepoLocal: mapsRepo,
      )),
      storage: storage,
    );

    // runApp(MyApp(api: repo, notificationService: localNotification));
    // runApp(MyApp());
    // if (enableCrashlytics) FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }, (error, stackTrace) {
    print(stackTrace);
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  final Api api;
  final MapsRepo mapsRepoLocal;
  final NotificationService notificationService;
  const MyApp({
    Key? key,
    required this.api,
    required this.notificationService,
    required this.mapsRepoLocal,
  }) : super(key: key);

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
        RepositoryProvider<NotificationService>.value(value: widget.notificationService),
        RepositoryProvider<MapsRepo>.value(value: widget.mapsRepoLocal),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
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
