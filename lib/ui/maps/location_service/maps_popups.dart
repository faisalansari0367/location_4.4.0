// import 'dart:async';
// import 'dart:developer';

// import 'package:bioplus/ui/maps/cubit/maps_cubit.dart';
// import 'package:bioplus/ui/maps/location_service/maps_repo.dart';
// import 'package:bioplus/ui/maps/models/polygon_model.dart';
// import 'package:bioplus/ui/maps/view/widgets/dialog/enter_property.dart';
// import 'package:bioplus/ui/maps/view/widgets/entry_form/entry_form.dart';
// import 'package:bioplus/widgets/dialogs/dialog_service.dart';
// import 'package:get/get.dart';
// // import 'package:local_notification/local_notification.dart';
// import 'package:rxdart/rxdart.dart';

// class MapsPopups {
//   // bool _isInside = false;
//   // final PushNotificationService _pushNotificationService;
//   final Set<PolygonModel> currentPolygons = {};
//   final Set<PolygonModel> disabledPolygons = {};

//   /// properties for that user has already notified
//   final Set<String> managerNotified = {};

//   late PolygonModel polygonModel;
//   Timer? _hidePopUpTimer;
//   Timer? _notifyManagerTimer;
//   Timer? _dontShowAgainTimer;
//   Timer? _canNotifyManagerAgainTimer;
//   // Timer? _showAgainTimer;

//   // bool _onQuestionsPage = false;
//   final MapsRepo mapsRepo;

//   final _hidePopupTime = 1.minutes;
//   // final _showAgainTime = 10.seconds;
//   final _notifyManagerTime = 5.minutes;
//   final _dontShowAgainTime = 15.minutes;
//   final _canNotifyManagerAgainTime = 30.minutes;
//   // bool isCanceled = false;

//   final void Function() sendNotificationToManager;
//   bool _isInside = false;
//   // final bool Function()  onEnterProperty;
//   final MapsCubit cubit;
//   MapsPopups(this.sendNotificationToManager, this.mapsRepo, this.cubit) {
//     init();
//     polygonCoverageAreas();
//   }

//   // const MapsPopups();
//   // BEHAVIORSubject controller:
//   final controller = BehaviorSubject<bool>.seeded(false);
//   final polygonsInCoverage = BehaviorSubject<Set<PolygonModel>>.seeded({});

//   void setPolygon(PolygonModel polygonModel) => this.polygonModel = polygonModel;

//   // show a pop up when user is inside the fence
//   // if he taps on the no don't show it for next 15 minutes

//   // after a minute hide the popup
//   // after 3 minutes if user is still inside the fence show a notified manager popup
//   // after 15 minutes sent an email to the manager
//   // add data to the log book

//   void init() {
//     _timer();
//     final userData = cubit.api.getUserData();
//     controller.listen((isInside) async {
//       log('user is in coverage $isInside');
//       if (_isInside != isInside) {
//         _isInside = isInside;
//         final polygon = cubit.getPolygon();
//         if (polygon != null) await mapsRepo.logBookEntry(userData!.pic!, null, polygon.id!);
//       } else {
//         return;
//       }
//       if (Get.isBottomSheetOpen ?? false) return;
//       if (Get.isDialogOpen ?? false) return;
//       if (isInside) {
//         if (_dontShowAgainTimer?.isActive ?? false) return;
//         if (_notifyManagerTimer?.isActive ?? false) return;
//         if (disabledPolygons.containsAll(currentPolygons)) return;
//         print('user said no to these polygons ${disabledPolygons.containsAll(currentPolygons)}');
//         print('polygons has changed ${disabledPolygons.containsAll(currentPolygons)}');
//         final isEntered = await _enterPropertyDialog(isInside);
//         if (isEntered) {
//           // BottomSheetService.showSheet(child: QuestionsSheet(polygonModel: polygonModel));
//         } else {
//           // user has said he is not entering the zone but he is in the zone
//           _notifyManagerDialog(isInside);

//           // don't show the dialog again for this time
//           _dontShowAgainTimer = Timer(
//             _dontShowAgainTime,
//             () {
//               disabledPolygons.clear();
//               _dontShowAgainTimer?.cancel();
//             },
//           );
//         }
//         // final result = onEnterProperty();
//         // _notifyManagerDialog();/
//       } else {
//         if (Get.isDialogOpen ?? false) Get.back();
//         _hidePopUpTimer?.cancel();
//         // _notifyManagerTimer?.cancel();
//       }
//     });
//   }

//   void _notifyManagerDialog(bool isInside) {
//     // _hidePopUpTimer = Timer(_hidePopupTime, () {
//     //   if (Get.isDialogOpen ?? false) Get.back();
//     // _notifyManagerTimer?.cancel();
//     if (_notifyManagerTimer?.isActive ?? false) return;
//     if (_canNotifyManagerAgainTimer?.isActive ?? false) return;
//     print('notify manager called');
//     _notifyManagerTimer = Timer(_notifyManagerTime, () async {
//       // if (_onQuestionsPage) return;
//       await 5.minutes.delay();
//       if (!isInside) return;
//       sendNotificationToManager();
//       _notifyManagerTimer?.cancel();
//       _canNotifyManagerAgainTimer = Timer(
//         _canNotifyManagerAgainTime,
//         () => _canNotifyManagerAgainTimer?.cancel(),
//       );
//       _notifyManagerTimer = null;
//     });
//     // });
//   }

//   Future<bool> _enterPropertyDialog(bool isInside) async {
//     var result = false;
//     if (Get.currentRoute != '/MapsPage') return false;
//     _hidePopUpTimer = Timer(_hidePopupTime, () {
//       if (Get.isDialogOpen ?? false) Get.back();
//     });
//     await DialogService.showDialog(
//       child: EnterProperty(
//         stream: polygonsInCoverage.stream,
//         onTap: (s) {
//           result = true;
//           _notifyManagerTimer?.cancel();
//           _notifyManagerTimer = null;
//           cubit.stopLocationUpdates();

//           Get.to(
//             () => EntryForm(polygonModel: s),
//           );
//           // Get.back();
//         },
//         onNO: () {
//           result = false;
//           disabledPolygons.addAll(currentPolygons);
//           _notifyManagerTimer?.cancel();
//           _notifyManagerTimer = null;
//         },
//       ),
//     );
//     return result;
//   }

//   void _timer() {}

//   void polygonCoverageAreas() {
//     polygonsInCoverage.listen(currentPolygons.addAll);
//   }

//   // newInit

// }

// // final cd =CallbackDebouncer();



// // callback debouncer
// // final db = CallbackDebouncer();
