// import 'package:bioplus/constants/hive_boxes.dart';
// import 'package:hive_flutter/adapters.dart';

// class CvdFormsService {
//   late Box _box;
//   CvdFormsService() {
//     _init();
//   }

//   Future<void> _init() async {
//     _box = await Hive.openBox(HiveBox.cvdBox);

//   }

//   Future<void> saveCvdForm(Map<String, Map<String, dynamic>> json) async {
//     try {
//       final cvdOfflineForms = await getCvdForms();
//       cvdOfflineForms.add(json);
//       await _box.put('cvdOfflineForms', cvdOfflineForms);
//     } on Exception {
//       rethrow;
//     }
//   }

//   Future<List<Map<String, Map<String, dynamic>>>> getCvdForms() async {
//     try {
//       final cvdOfflineForms = _box.get('cvdOfflineForms') ?? [];
//       return List<Map<String, Map<String, dynamic>>>.from(cvdOfflineForms);
//     } on Exception {
//       rethrow;
//     }
//   }
// }
