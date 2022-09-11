// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cvd_cubit.dart';

class CvdState extends Equatable {
  final List<Forms> forms;
  final List<CvdFormData> formData;
  final List<FormStepper> formStepper;
  final Map data;
  final int currentStep;

  CvdState({
    this.data = const {},
    this.forms = const [],
    this.formData = const [],
    this.formStepper = const [],
    this.currentStep = 0,
  });

  @override
  List<Object> get props => [forms, formData, formStepper, currentStep, data];

  CvdState copyWith({
    List<Forms>? forms,
    List<CvdFormData>? formData,
    List<FormStepper>? formStepper,
    Map? data,
    int? currentStep,
  }) {
    return CvdState(
      forms: forms ?? this.forms,
      formData: formData ?? this.formData,
      formStepper: formStepper ?? this.formStepper,
      data: data ?? this.data,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
