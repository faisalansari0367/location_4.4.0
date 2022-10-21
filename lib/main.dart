import 'dart:async';
import 'dart:math';

import 'package:api_repo/api_repo.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/services/notifications/connectivity/connectivity_service.dart';
import 'package:background_location/theme/color_constants.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/location_service/polygons_service.dart';
import 'package:background_location/ui/splash/new_splash_screen.dart';
import 'package:background_location/ui/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_notification/local_notification.dart';

import 'services/notifications/push_notifications.dart';
import 'ui/maps/location_service/maps_api.dart';
import 'ui/maps/location_service/maps_repo_local.dart';

const enableCrashlytics = !kDebugMode;

Future<void> showNotification({
  required String title,
  required String body,
  int? id,
}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      notificationLayout: NotificationLayout.BigText,
      id: id ?? Random().nextInt(2147483647),
      title: title,
      category: NotificationCategory.Message,
      body: body,
      channelKey: 'basic_channel',
    ),
  );
}

Future<void> bgHandler(RemoteMessage message) async {
  // dev.log(message.toMap().toString());
  await showNotification(
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    id: message.notification.hashCode,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(() async {
    await Firebase.initializeApp();
    await Hive.initFlutter();
    final _box = await Hive.openBox('storage');
    final notifications = AwesomeNotifications();
    final repo = ApiRepo();
    final localApi = LocalApi();
    await localApi.init(baseUrl: ApiConstants.baseUrl, box: _box);
    await repo.init(baseUrl: ApiConstants.baseUrl, box: _box);

    final mapsRepo = MapsApi(client: repo.client);
    // final mapsRepo = MapsRepoLocal();
    await mapsRepo.init();
    await notifications.initialize(
      'resource://drawable/itrak_logo_transparent',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color.fromARGB(255, 0, 0, 0),
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
    final pushNotification = PushNotificationService(localNotificationService: localNotification);
    FirebaseMessaging.onBackgroundMessage(bgHandler);

    await pushNotification.initmessaging();
    // pushNotification.setBgHandler();

    // final storage = await HydratedStorage.build(
    //   storageDirectory: await getApplicationDocumentsDirectory(),
    // );
    runApp(
      MyApp(
        localApi: localApi,
        pushNotificationService: pushNotification,
        api: repo,
        notificationService: localNotification,
        mapsRepo: mapsRepo,
      ),
    );

    // HydratedBlocOverrides.runZoned(
    //   storage: storage,
    // );

    // runApp(MyApp(api: repo, notificationService: localNotification));
    // runApp(MyApp());
    if (enableCrashlytics) FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }, (error, stackTrace) {
    // print(stackTrace);
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  final Api api;
  final MapsRepo mapsRepo;
  final NotificationService notificationService;
  final PushNotificationService pushNotificationService;
  final LocalApi localApi;

  const MyApp({
    Key? key,
    required this.api,
    required this.notificationService,
    required this.mapsRepo,
    required this.pushNotificationService,
    required this.localApi,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _initializeFlutterFire() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enableCrashlytics);
  }

  // late MapsRepoLocal mapsRepoLocal;
  @override
  void initState() {
    MyConnectivity();
    // mapsRepoLocal = MapsRepoLocal();
    // mapsRepoLocal.init();
    _initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Api>.value(value: widget.api),
        RepositoryProvider<NotificationService>.value(value: widget.notificationService),
        RepositoryProvider<PushNotificationService>.value(value: widget.pushNotificationService),
        RepositoryProvider<MapsRepo>.value(value: widget.mapsRepo),
        RepositoryProvider<LocalApi>.value(value: widget.localApi),
        RepositoryProvider<PolygonsService>(create: (context) => PolygonsService()),
        RepositoryProvider<MapsRepoLocal>(create: (context) => MapsRepoLocal()..init()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: GoogleFonts.nunito().fontFamily,
          backgroundColor: Colors.white,
          // primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: kPrimaryColor,
              ),

          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        getPages: [
          GetPage(name: '/', page: () => const NewSplashScreen()),
        ],

        // home: SplashScreen(),
        home: ScreenUtilInit(
          designSize: Get.size,
          builder: (context, child) => const SplashScreen(),
          child: const SplashScreen(),
        ),
      ),
    );
  }
}
