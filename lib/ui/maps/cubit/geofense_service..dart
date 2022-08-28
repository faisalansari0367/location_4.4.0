// import 'dart:developer';

// import 'package:geofence_service/geofence_service.dart';
// // import 'package:poly_geofence_service/poly_geofence_service.dart';

// class MyGeofenceService {
//   // static late final MyGeofenceService instance;
//   static final MyGeofenceService _singleton = MyGeofenceService._internal();
//   // final _geofenceService = PolyGeofenceService.instance.setup(
//   //     interval: 5000,
//   //     accuracy: 100,
//   //     loiteringDelayMs: 60000,
//   //     statusChangeDelayMs: 10000,

//   //     allowMockLocations: false,

//   //     printDevLog: false);
//   final geofenceService = GeofenceService.instance.setup(
//       interval: 5000,
//       accuracy: 100,
//       loiteringDelayMs: 60000,
//       statusChangeDelayMs: 10000,
//       useActivityRecognition: true,
//       allowMockLocations: true,
//       printDevLog: false,
//       geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

//   factory MyGeofenceService() {
//     return _singleton;
//   }

//   MyGeofenceService._internal();

//   // final geofenceService = GeofenceService.instance.setup(
//   //     interval: 5000,
//   //     accuracy: 100,
//   //     loiteringDelayMs: 60000,
//   //     statusChangeDelayMs: 10000,
//   //     useActivityRecognition: true,
//   //     allowMockLocations: false,
//   //     printDevLog: false,
//   //     geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

//   final _geofenceList = <Geofence>[
//     Geofence(
//       id: 'place_1',
//       latitude: 28.4923496,
//       longitude: 77.2289945,
//       radius: [
//         // GeofenceRadius(id: 'radius_100m', length: 100),
//         GeofenceRadius(id: 'radius_25m', length: 40),
//         // GeofenceRadius(id: 'radius_250m', length: 250),
//         // GeofenceRadius(id: 'radius_200m', length: 200),
//       ],
//     ),
//   ];

// // Create a [PolyGeofence] list.
//   // final _polyGeofenceList = <PolyGeofence>[

//   //   PolyGeofence(

//   //     id: 'Yongdusan_Park',
//   //     data: {
//   //       'address': '37-55 Yongdusan-gil, Gwangbokdong 2(i)-ga, Jung-gu, Busan',
//   //       'about':
//   //           'Mountain park known for its 129m-high observation tower, statues & stone monuments.',
//   //     },

//   //     polygon: <LatLng>[
//   //        const LatLng(28.4923496, 77.2289945)
//   //       // const LatLng(35.101727, 129.031665),
//   //       // const LatLng(35.101815, 129.033458),
//   //       // const LatLng(35.100032, 129.034055),
//   //       // const LatLng(35.099324, 129.033811),
//   //       // const LatLng(35.099906, 129.031927),
//   //       // const LatLng(35.101080, 129.031534),
//   //     ],
//   //   ),
//   // ];

//   // This function is to be called when the geofence status is changed.
//   Future<void> _onGeofenceStatusChanged(Geofence geofence, GeofenceRadius geofenceRadius,
//       GeofenceStatus geofenceStatus, Location location) async {
//     log('geofence: ${geofence.toJson()}');
//     log('geofenceRadius: ${geofenceRadius.toJson()}');
//     log('geofenceStatus: ${geofenceStatus.toString()}');
//     // _geofenceStreamController.sink.add(geofence);
//   }

// // This function is to be called when the activity has changed.
//   void _onActivityChanged(Activity prevActivity, Activity currActivity) {
//     log('prevActivity: ${prevActivity.toJson()}');
//     log('currActivity: ${currActivity.toJson()}');
//     // _activityStreamController.sink.add(currActivity);
//   }

// // This function is to be called when the location has changed.
//   void _onLocationChanged(Location location) {
//     log('location: ${location.toJson()}');
//   }

// // This function is to be called when a location services status change occurs
// // since the service was started.
//   void _onLocationServicesStatusChanged(bool status) {
//     log('isLocationServicesEnabled: $status');
//   }

// // This function is used to handle errors that occur in the service.
//   void _onError(error) {
//     final errorCode = getErrorCodesFromError(error);
//     if (errorCode == null) {
//       print('Undefined error: $error');
//       return;
//     }

//     print('ErrorCode: $errorCode');
//   }

//   void init() {
    
//     geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
//     geofenceService.addLocationChangeListener(_onLocationChanged);
//     geofenceService.addLocationServicesStatusChangeListener(_onLocationServicesStatusChanged);
//     geofenceService.addActivityChangeListener(_onActivityChanged);
//     geofenceService.addStreamErrorListener(_onError);
//     geofenceService.start(_geofenceList).catchError(_onError);
//   }
// }
