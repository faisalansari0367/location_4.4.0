// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:ui';

import 'package:api_repo/api_repo.dart';

class LogbookResponseModel {
  String? status;
  List<LogbookEntry>? data;

  LogbookResponseModel({this.status, this.data});

  LogbookResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <LogbookEntry>[];
      json['data'].forEach((v) {
        data!.add(LogbookEntry.fromJson(_fromMap(v)));
      });
    }
  }

  Map<String, dynamic> _fromMap(map) => Map<String, dynamic>.from(map);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Entries {
//   int? id;
//   String? date;
//   dynamic form;
//   String? createdAt;
//   String? updatedAt;

//   Entries({this.id, this.date, this.form, this.createdAt, this.updatedAt});

//   Entries.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     date = json['date'];
//     // if (json['form'] != null) {
//     //   // form = <Null>[];
//     //   // json['form'].forEach((v) {
//     //   //   form!.add(void.fromJson(v));
//     //   // });
//     // }
//     form = json['form'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['date'] = date;
//     if (form != null) {
//       // data['form'] = form!.map((v) => v.toJson()).toList();
//     }
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     return data;
//   }

//   String formmatedDate() {
//     final dt = DateTime.parse(createdAt!).toLocal();
//     final formatted = DateFormat('E, d MMM yyyy h:mm a').format(dt);
//     return formatted;
//   }

//   @override
//   bool operator ==(covariant Entries other) {
//     if (identical(this, other)) return true;

//     return other.id == id &&
//         other.date == date &&
//         listEquals(other.form, form) &&
//         other.createdAt == createdAt &&
//         other.updatedAt == updatedAt;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^ date.hashCode ^ form.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
//   }
// }

class LogbookEntry {
  int? id;
  DateTime? enterDate;
  DateTime? exitDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Geofence? geofence;
  late LogbookFormModel form;

  UserData? user;

  LogbookEntry({
    this.id,
    this.enterDate,
    this.exitDate,
    required this.form,
    this.createdAt,
    this.updatedAt,
    this.geofence,
  });

  LogbookEntry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enterDate = _getDateTime(json['enterDate']);
    exitDate = _getDateTime(json['exitDate']);

    form = LogbookFormModel.fromJson(json);
    createdAt = _getDateTime(json['createdAt']);
    updatedAt = _getDateTime(json['updatedAt']);
    user = json['user'] != null ? UserData.fromJson(Map<String, dynamic>.from(json['user'])) : null;
    geofence = json['geofence'] != null ? Geofence.fromJson(Map<String, dynamic>.from(json['geofence'])) : null;
  }

  // Map<String, dynamic> _fromMap(map) => Map<String, dynamic>.from(map);

  // LogbookEntry.getId(Map<String, dynamic> json) {
  //   id = json['id'];
  // }

  DateTime? _getDateTime(String? date) => date != null ? DateTime.tryParse(date)?.toLocal() : null;

  Map<String, dynamic> saveId() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['enterDate'] = enterDate?.toIso8601String();
    data['exitDate'] = exitDate?.toIso8601String();
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data.addAll(form.toJson());
    if (user != null) {
      data['user'] = user!.toJson();
    }

    if (geofence != null) {
      data['geofence'] = geofence!.toJson();
    }
    return data;
  }
}

class LogbookFormModel {
  final bool isPeopleTravelingWith;
  final List<String> usersTravellingAlong;
  final bool isQfeverVaccinated;
  final bool isFluSymptoms;
  final bool isOverSeaVisit;
  final bool isAllMeasureTaken;
  final bool isOwnerNotified;
  final String rego;
  final String riskRating;
  final DateTime expectedDepartureTime;
  final DateTime expectedDepartureDate;
  final String signature;

  LogbookFormModel({
    required this.isPeopleTravelingWith,
    this.usersTravellingAlong = const [],
    required this.isQfeverVaccinated,
    required this.isFluSymptoms,
    required this.isOverSeaVisit,
    required this.isAllMeasureTaken,
    required this.isOwnerNotified,
    required this.rego,
    required this.riskRating,
    required this.expectedDepartureTime,
    required this.expectedDepartureDate,
    required this.signature,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'isPeopleTravelingWith': isPeopleTravelingWith,
      'userTravelingAlong': usersTravellingAlong,
      'isQfeverVaccinated': isQfeverVaccinated,
      'isFluSymptoms': isFluSymptoms,
      'isOverSeaVisit': isOverSeaVisit,
      'isAllMeasureTaken': isAllMeasureTaken,
      'isOwnerNotified': isOwnerNotified,
      'rego': rego,
      'riskRating': riskRating,
      'expectedDepartureTime': expectedDepartureTime.toIso8601String(),
      'expectedDepartureDate': expectedDepartureDate.toIso8601String(),
      'signature': signature,
    };
    return map;
  }

  // fromJson
  LogbookFormModel.fromJson(Map<String, dynamic> json)
      : isPeopleTravelingWith = json['isPeopleTravelingWith'] ?? false,
        usersTravellingAlong = List<String>.from(json['userTravelingAlong'] ?? []),
        isQfeverVaccinated = json['isQfeverVaccinated'] ?? false,
        isFluSymptoms = json['isFluSymptoms'] ?? false,
        isOverSeaVisit = json['isOverSeaVisit'] ?? false,
        isAllMeasureTaken = json['isAllMeasureTaken'] ?? false,
        isOwnerNotified = json['isOwnerNotified'] ?? false,
        rego = json['rego'] ?? '',
        riskRating = json['riskRating'] ?? '',
        expectedDepartureTime = DateTime.parse(json['expectedDepartureTime'] ?? DateTime.now().toIso8601String()),
        expectedDepartureDate = DateTime.parse(json['expectedDepartureDate'] ?? DateTime.now().toIso8601String()),
        signature = json['signature'] ?? '';

  final _model = GlobalDeclarationFormKeys();

  GlobalDeclarationFormKeys get keys => _model;
  String question(key) => _model.question(key);

  bool get isEmpty => signature.isEmpty;

  bool get isNotEmpty => !isEmpty;
}

// class LogbookFormField {
//   String? field;
//   dynamic value;

//   LogbookFormField({this.field, this.value});

//   LogbookFormField.fromJson(Map<String, dynamic> json) {
//     field = json['field'];
//     value = json['value'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['field'] = field;
//     data['value'] = value;
//     return data;
//   }
// }

class Geofence {
  int? id;
  String? name;
  Color? color;
  Points? points;
  Origin? center;
  String? pic;
  String? createdAt;
  String? updatedAt;

  Geofence({this.id, this.name, this.color, this.points, this.center, this.pic, this.createdAt, this.updatedAt});

  Geofence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = (json['color']) != null ? colorFromHex(json['color']) : null;
    points = json['points'] != null ? Points.fromJson(_fromMap(json['points'])) : null;
    center = json['center'] != null ? Origin.fromJson(_fromMap(json['center'])) : null;
    pic = json['pic'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> _fromMap(map) => Map<String, dynamic>.from(map);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color == null ? null : colorToHex(color!);
    if (points != null) {
      data['points'] = points!.toJson();
    }
    if (center != null) {
      data['center'] = center!.toJson();
    }
    data['pic'] = pic;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }

  String colorToHex(Color color) => color.value.toRadixString(16).padLeft(6, '0');
  Color colorFromHex(String hex) => Color(int.parse(hex, radix: 16));
}

class Points {
  String? type;
  List<List>? coordinates;

  Points({this.type, this.coordinates});

  Points.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = <List>[];
      // json['coordinates'].forEach((v) { coordinates!.add(List.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (coordinates != null) {
      // data['coordinates'] = coordinates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coordinates {
  // Coordinates({});

  Coordinates.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class Origin {
  String? type;
  List<int>? coordinates;

  Origin({this.type, this.coordinates});

  Origin.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class GlobalDeclarationFormKeys {
  GlobalDeclarationFormKeys();
  final isPeopleTravelingWith = 'isPeopleTravelingWith',
      userTravelingAlong = 'userTravelingAlong',
      isQfeverVaccinated = 'isQfeverVaccinated',
      isFluSymptoms = 'isFluSymptoms',
      isOverSeaVisit = 'isOverSeaVisit',
      isAllMeasureTaken = 'isAllMeasureTaken',
      isOwnerNotified = 'isOwnerNotified',
      rego = 'rego',
      riskRating = 'riskRating',
      expectedDepartureTime = 'expectedDepartureTime',
      expectedDepartureDate = 'expectedDepartureDate',
      signature = 'signature';

  Map<String, dynamic> get _questions => {
        isPeopleTravelingWith: '1. Are other people travelling onto the property with you?',
        isQfeverVaccinated: '2. Have all visitors had a Q Fever vaccination?',
        isFluSymptoms: '3. Do you have cold or flu symptoms?',
        isOverSeaVisit: '4. Have any visitors been overseas in the last 7 days?',
        isAllMeasureTaken:
            '5. Have you taken all reasonable measures to ensure that shoes, clothing and equipment are free from potential weed and disease contaminants:',
        isOwnerNotified:
            '6. Have you made reasonable attempts to notify the owner/manager of the property that you are visiting today?',
        rego: 'Rego',
        // 'selfDeclaration':
        //     'I declare that any animals/products I am transporting are accompanied by correct movement documentation.',
        riskRating: 'Risk Rating',
        expectedDepartureTime: 'Expected Departure Time',
        expectedDepartureDate: 'Expected Departure Date',
        signature: 'Signature',
      };

  String question(String key) => _questions[key] ?? '';

  List<String> get all => [
        isPeopleTravelingWith,
        userTravelingAlong,
        isQfeverVaccinated,
        isFluSymptoms,
        isOverSeaVisit,
        isAllMeasureTaken,
        isOwnerNotified,
        rego,
        riskRating,
        expectedDepartureTime,
        expectedDepartureDate,
        signature,
      ];
}
