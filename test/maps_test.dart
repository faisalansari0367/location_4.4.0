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
