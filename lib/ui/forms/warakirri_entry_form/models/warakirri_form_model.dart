// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';

import 'package:bioplus/ui/forms/models/global_form_model.dart';

class WarakirriFormModel {
  final QuestionData arePeopleTravelingWith;
  List<String> userTravelingAlong = const [];
  final QuestionData isFluSymptoms;
  final QuestionData isOverSeaVisit;
  final QuestionData expectedDepartureDate;
  final QuestionData isInducted;
  final QuestionData isConfinedSpace;
  final QuestionData warakirriFarm;
  final QuestionData additionalInfo;

  final _model = WarakirriQuestionFormModel();

  WarakirriFormModel({
    required this.arePeopleTravelingWith,
    required this.userTravelingAlong,
    required this.isFluSymptoms,
    required this.isOverSeaVisit,
    required this.expectedDepartureDate,
    required this.isInducted,
    required this.isConfinedSpace,
    required this.warakirriFarm,
    required this.additionalInfo,
  });

  String question(String key) => _model.question(key);

  factory WarakirriFormModel.fromLocal() {
    final model = WarakirriQuestionFormModel();
    final question = model.question;

    return WarakirriFormModel(
      additionalInfo: QuestionData<String>(
        question: question(model.additionalInfo),
        key: model.additionalInfo,
      ),
      warakirriFarm: QuestionData<String>(
        question: model.question(model.warakirriFarm),
        key: model.warakirriFarm,
        value: 'Welbourne',
      ),
      isConfinedSpace: QuestionData<bool>(
        question: question(model.isConfinedSpace),
        key: model.isConfinedSpace,
      ),
      arePeopleTravelingWith: QuestionData<bool>(
        question: question(model.isPeopleTravelingWith),
        key: model.isPeopleTravelingWith,
      ),
      isInducted: QuestionData<bool>(
        question: question(model.hasBeenInducted),
        key: model.hasBeenInducted,
      ),
      userTravelingAlong: [],
      isFluSymptoms: QuestionData<bool>(
        question: question(model.isFluSymptoms),
        key: model.isFluSymptoms,
      ),
      isOverSeaVisit: QuestionData<bool>(
        question: question(model.isOverSeaVisit),
        key: model.isOverSeaVisit,
      ),
      expectedDepartureDate: QuestionData<String>(
        question: question(model.expectedDepartureDate),
        key: model.expectedDepartureDate,
        value: DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final map = {};
    map[arePeopleTravelingWith.key] = arePeopleTravelingWith.value;
    if (userTravelingAlong.isNotEmpty) {
      map[_model.userTravelingAlong] = userTravelingAlong;
    }
    if (additionalInfo.value != null) {
      map[additionalInfo.key] = additionalInfo.value;
    }
    map[isFluSymptoms.key] = isFluSymptoms.value;
    map[isOverSeaVisit.key] = isOverSeaVisit.value;
    map[expectedDepartureDate.key] = expectedDepartureDate.value;
    map[isInducted.key] = isInducted.value;
    map[isConfinedSpace.key] = isConfinedSpace.value;
    map[warakirriFarm.key] = warakirriFarm.value;

    return Map<String, dynamic>.from(map);
  }
}
