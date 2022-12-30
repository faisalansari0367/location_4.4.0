// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cvd_cubit.dart';

class CvdState extends Equatable {
  final List<Forms> forms;
  // final List<CvdFormData> formData;
  final Map data;
  final int currentStep;
  final bool isLoading;
  final bool showOfflineForms;


  const CvdState({
    this.showOfflineForms = false,
    this.isLoading = false,
    this.data = const {},
    this.forms = const [],
    // this.formData = const [],
    this.currentStep = 0,
  });

  @override
  List<Object> get props => [forms,  currentStep, data, isLoading, showOfflineForms];

  CvdState copyWith({
    bool? isLoading,
    List<Forms>? forms,
    // List<CvdFormData>? formData,
    Map? data,
    int? currentStep,
    bool? showOfflineForms,
  }) {
    return CvdState(
      showOfflineForms: showOfflineForms ?? this.showOfflineForms,
      isLoading: isLoading ?? this.isLoading,
      forms: forms ?? this.forms,
      // formData: formData ?? this.formData,
      data: data ?? this.data,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
