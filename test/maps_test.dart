// import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
// import 'package:background_location/ui/maps/location_service/maps_popups.dart';
// import 'package:background_location/ui/maps/models/polygon_model.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main(List<String> args) {
//   Future<void> sendNotification() async {

//   }
//   // final MapsPopups mapsPopups = MapsPopups(sendNotification);
//   final data = [
//     {
//       'id': 17,
//       'name': "Near house",
//       'color': "ff7299ef",
//       'points': [
//         {'latitude': 28.49232482818986, 'longitude': 77.22880493849516},
//         {'latitude': 28.492327774868077, 'longitude': 77.22915161401033},
//         {'latitude': 28.49254258748833, 'longitude': 77.22914926707745},
//         {'latitude': 28.49256586619595, 'longitude': 77.22879689186811},
//         {'latitude': 28.49232482818986, 'longitude': 77.22880493849516},
//       ],
//     }
//   ];
//   final polygon = PolygonModel.fromJson(data.first);
//   group('Maps Popup', (() {
//     final trackInsideProperty = <String>{};
//     // final MapsPopups mapsPopups = MapsPopups(polygon);
//     test('Show pop up when user enters into property', () {
//       final isInside = MapsToolkitService.isInsidePolygon(latLng: polygon.points.first, polygon: polygon.points);
//       mapsPopups.controller.add(isInside);

//       // testWidgets('check if dialog is open', (tester) {

//       // });
//       // if (isInside) {

//       //   // mapsPopups.setIsInside(true);
//       //   // expect(isInside, mapsPopups.controller);
//       // }
//     });
//   }));
// }

import 'dart:async';
import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class MarkExitHandler {
  // PolygonModel? model;
  bool isExiting;
  // final Api api;
  Timer? timer;

  int called = 0;

  MarkExitHandler({
    // required this.model,
    this.isExiting = false,
    // required this.api,
    this.timer,
  });

  void callExit([bool isExiting = false]) {
    // model = polygonModel;
    this.isExiting = isExiting;
    cancel();
    timer = Timer(2.seconds, callback);
    printTimer();
  }

  void printTimer() {
    Timer.periodic(1.seconds, (_) {
      log('timer is running ${timer?.isActive}');
    });
  }

  void cancel() => timer?.cancel();

  void markExit() async {}

  void callback() {
    log('callback called');
    called++;
  }
}

void main() async {
  // mark exit handler test
  final markExit = MarkExitHandler();
  group('markExit Handler', () {
    test('Mark exit', () async {
      markExit.callExit(true);
      await 1.seconds.delay();
      markExit.callExit(false);
      await 1.seconds.delay();
      markExit.callExit(true);
      await 3.seconds.delay();
      markExit.callExit(true);
      await 2.seconds.delay();

      expect(markExit.called, 2);
    });
  });
}
