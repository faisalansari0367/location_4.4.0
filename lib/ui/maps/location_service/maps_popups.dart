import 'dart:async';
import 'dart:developer';

import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:background_location/ui/maps/view/widgets/dialog/enter_property.dart';
import 'package:background_location/ui/maps/view/widgets/dialog/notify_manager.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class MapsPopups {
  // bool _isInside = false;
  late PolygonModel polygonModel;
  Timer? _hidePopUpTimer;
  Timer? _fiveMinutesTimer;
  bool _onQuestionsPage = false;

  final _hidePopupTime = 5.seconds;
  final _notifyManagerTime = 10.seconds;
  // CallbackDebouncer _callbackDebouncer = CallbackDebouncer(1.minutes);

  MapsPopups() {
    init();
  }

  // const MapsPopups();
  // BEHAVIORSubject controller:
  final controller = BehaviorSubject<bool>.seeded(false);
  final polygonsInCoverage = BehaviorSubject<Set<PolygonModel>>.seeded({});

  void setPolygon(PolygonModel polygonModel) {
    this.polygonModel = polygonModel;
  }

  void init() {
    print('initiliasing popups');
    controller.listen((isInside) {
      log('isInside $isInside, isDialogOpen ${Get.isDialogOpen}');
      if (_onQuestionsPage) return;
      if (Get.isDialogOpen ?? false) return;
      if (isInside) {
        if (_fiveMinutesTimer != null) return;
        int counter = 0;
        Timer.periodic(1.seconds, (timer) {
          print(counter++);
        });
        DialogService.showDialog(
          child: EnterProperty(
            stream: polygonsInCoverage.stream,
            onYES: () {
              _onQuestionsPage = true;
              _fiveMinutesTimer?.cancel();
              _fiveMinutesTimer = null;
            },
          ),
        );
        _hidePopUpTimer = Timer(_hidePopupTime, () {
          if (Get.isDialogOpen ?? false) Get.back();
          if (_fiveMinutesTimer != null) return;
          // int counter = 0;
          // Timer.periodic(1.seconds, (timer) {
          //   print(counter++);
          // });
          _fiveMinutesTimer = Timer(_notifyManagerTime, () {
            if (_onQuestionsPage) return;
            DialogService.showDialog(child: NotifyManagerDialog());
            _fiveMinutesTimer?.cancel();
            _fiveMinutesTimer = null;
          });
        });
      } else {
        if (Get.isDialogOpen ?? false) Get.back();
        _hidePopUpTimer?.cancel();
        _fiveMinutesTimer?.cancel();
      }
    });
  }

  // void setIsInside(bool value) {
  //   if (Get.isDialogOpen ?? false) return;

  //   DialogService.showDialog(child: EnterProperty(polygonModel: polygonModel));
  //   Future.delayed(1.minutes, () {
  //     if (Get.isDialogOpen ?? false) Get.back();
  //   });
  //   Future.delayed(5.minutes, () {
  //     DialogService.showDialog(child: NotifyManagerDialog());
  //   });
  // }
}
