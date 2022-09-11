import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/src/api/api_repo.dart';
import 'package:api_repo/src/local_api/src/local_api.dart';
import 'package:api_repo/src/user/src/models/user_forms_data.dart';
import 'package:background_location/ui/cvd_form/models/cvd_form_data.dart';
import 'package:background_location/ui/cvd_form/widgets/form_stepper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'cvd_state.dart';

class CvdCubit extends Cubit<CvdState> {
  final Api api;
  final LocalApi localApi;
  CvdCubit({required this.api, required this.localApi}) : super(CvdState()) {
    getCvdForm();
  }

  final map = {};
  final PageController pageController = PageController();
  final List<String> stepNames = [
    'Vendor Details',
    'Buyer Details',
    'Commodity Details',
    'Part A - Product Integrity',
    'Part B - Chemical Use',
    'Self Declaration',
  ];

  void changeCurrent(int step, {bool isNext = false, bool isPrevious = false}) {
    late int _step = step;
    if (isNext) {
      step = state.currentStep + 1;
    } else if (isPrevious) {
      step = state.currentStep - 1;
    } else {}
    emit(state.copyWith(currentStep: _step));
    pageController.animateToPage(
      _step,
      curve: Curves.fastOutSlowIn,
      duration: 500.milliseconds,
    );
  }

  bool isStepCompleted(int index) {
    final key = stepNames.elementAt(index);
    final data = state.data.containsKey(key);
    return data;
  }

  void addFormData(Map data) {
    final map = {...state.data};
    final stepName = stepNames[state.currentStep];
    map.addAll({stepName: data});
    emit(state.copyWith(data: map));
  }

  void getCvdForm() {
    // final result = await api.getUserForms();
    // result.when(success: success, failure: failure);
    final data = formData();
    // final widgets = <Widget>[];

    final steps = <FormStepper>[];
    // final widgets = <Widget>[];
    data.forEach((element) {
      final formDataList = <CvdFormData>[];
      final list = element['data'] as List<String>;
      list.forEach((e) {
        final field = CvdFormData(
          name: e,
          controller: TextEditingController(),
        );
        formDataList.add(field);
        // steps.add(FormStepper(heading: heading, content: ));
        // emit(state.copyWith())
      });
      steps.add(
        FormStepper(
          heading: element['field'].toString().toUpperCase(),
          formDataList: formDataList,
        ),
      );
    });

    emit(state.copyWith(formStepper: steps));
  }

  Object? failure(NetworkExceptions error) {
    return null;
  }

  void success(UserFormsData data) {
    emit(state.copyWith(forms: data.data?.forms));
    // data.data.forms;
  }

  List<Map<String, Object>> formData() {
    final commonFields = [
      "Name",
      "Address",
      "Town",
      "Tel",
      "Fax",
      "Email",
      "National Grower Registration (NGR) No",
      "Property Identification Code (PIC)",
    ];

    return [
      {
        'field': 'vendor details',
        'data': [
          ...commonFields,
          "Vendors contract/ reference No",
        ],
      },
      {
        'field': 'Buyer details',
        'data': [
          ...commonFields,
          "Buyers contract No",
        ],
      },
      {
        'field': 'Commodity details',
        'data': [
          // "Vendors contract/ reference No",
          "Commodity",
          'Variety',
          'Variety',

          'Delivery Period',
          'Quantity',
          'Quantity',

          "Total Quantity",
        ],
      },
      {
        'field': 'Part A – Product Integrity',
        'data': [
          // "Vendors contract/ reference No",
          "Commodity",
          'Variety',
          'Variety',

          'Delivery Period',
          'Quantity',
          'Quantity',

          "Total Quantity",
        ],
      },
      {
        'field': 'Part B – Chemical Us',
        'data': [
          // "Vendors contract/ reference No",
          "Commodity",
          'Variety',
          'Variety',

          'Delivery Period',
          'Quantity',
          'Quantity',

          "Total Quantity",
        ],
      },
      {
        'field': 'Self Declaration',
        'data': [
          // "Vendors contract/ reference No",
          "Commodity",
          'Variety',
          'Variety',

          'Delivery Period',
          'Quantity',
          'Quantity',

          "Total Quantity",
        ],
      },
      // partAProductIntegrity(),
    ];
    // },
    // "Name",
    // "Address",
    // "Town",
    // "Tel  ",
    // "Fax",
    // "Email",
    // "National Grower Registration (NGR) No",
    // "Property Identification Code (PIC)",
    // "Buyers contract No",
    // "Commodity_____________________________________________",
    // "Delivery Period____________________________________________",
    // "Variety_________________________________________________",
    // "Quantity__________________________________________________",
    // "Variety_________________________________________________",
    // "Quantity__________________________________________________",
    // "TOTAL QUANTITY:_________________________________________",
    // "1. Commodity source (tick one)",
    // "Single Source, Single Storage (eg off the header)",
    // "Single Source, Comingled Storage (eg farm silo)",
    // "Multi-Vendor Storage (eg grain depot, cotton gin seed storage)",
    // "Factory Developed Product (eg ethanol plant, gluten plant)",
    // "2. Does this commodity contain restricted animal materials (eg meat and bone meal)?",
    // "No Yes",
    // "3. With respect to Genetically Modified Organisms, this commodity: (tick one)",
    // "Is non GMO as defined by 99% non GMO",
    // "Contains greater than 5% GMO or content unknown.",
    // "Is non GMO as defined by 95% non GMO",
    // "4. Is this commodity within a withholding period (WHP), Export Slaughter Interval (ESI) or Export Animal Feed Interval (EAFI) following",
    // "treatment with any plant chemical including a pickling or seed treatment, fumigant, pesticide or insecticide?",
    // "No Yes, enter details in the table below",
    // "Chemical applied Rate (Tonne/ Ha) Application date WHP/ ESI/ EAFI",
    // "5. Has the commodity been grown and/or stored under an independently audited QA program which includes chemical residue",
    // "management?",
    // "No Yes, provide details",
    // "QA program________________________________________ Accreditation/ Certification Number___________________________",
    // "If this commodity has been grown or stored under such a QA program, please now read and sign Part C. If not, please now complete",
    // "the remainder of Part B.",
    // "6. Is the vendor of this commodity currently aware of its full chemical treatment history or holds a CVD containing this history?",
    // "No Yes",
    // "7. List all known adjacent crops grown within 100 metres of this commodity (only applicable for single source commodities)",
    // "8. If the commodity is a by-product, has a risk assessment been completed? (tick one)",
    // "No Yes, attach copy of risk assessment N/A (see explanatory notes)",
    // "9. Has the commodity been analysed for chemical residues or toxins by a lab accredited by NATA for the specific test required?",
    // "No Yes, attach details of test results",
    // "I, _________________________________________________of______________________________________________________________declare that:",
    // "a) I am the duly authorised representative of the vendor supplying the commodity;",
    // "b) All the information in this document is true and correct;",
    // "c) I have read, understood and answered all questions in accordance with the explanatory notes;",
    // "d) I understand that regulatory authorities may take legal action, and purchasers may seek damages if the information provided is false or",
    // "misleading",
    // "Signature__________________________________________________________Date_______________________________________"
    // ];
  }

  Map<String, Object> partAProductIntegrity() {
    return {
      'field': 'Part A – Product Integrity',
      'data': [
        {
          'field': "commoditry source (tick one)",
          'options': [
            {
              'id': 1,
              'value': 'Single Source, Single Storage (eg off the header)',
            },
            {
              'id': 2,
              'value': 'Single Source, Comingled Storage (eg farm silo)',
            },
            {
              'id': 3,
              'value': 'Multi-Vendor Storage (eg grain depot, cotton gin seed storage)',
            },
            {
              'id': 4,
              'value': 'Factory Developed Product (eg ethanol plant, gluten plant)',
            }
          ]
        },
        {
          "field": "Does this commodity contain restricted animal materials (eg meat and bone meal)?",
          'options': [
            {
              'id': 1,
              'value': 'Single Source, Single Storage (eg off the header)',
            },
            {
              'id': 2,
              'value': 'Single Source, Comingled Storage (eg farm silo)',
            },
            {
              'id': 3,
              'value': 'Multi-Vendor Storage (eg grain depot, cotton gin seed storage)',
            },
            {
              'id': 4,
              'value': 'Factory Developed Product (eg ethanol plant, gluten plant)',
            }
          ]
        },
        {
          "field": "With respect to Genetically Modified Organisms, this commodity: (tick one)",
          'options': [
            {
              'id': 1,
              'value': 'Is non GMO as defined by 99% non GMO',
            },
            {
              'id': 2,
              'value': 'Is non GMO as defined by 95% non GMO',
            },
            {
              'id': 3,
              'value': 'Contains greater than 5% GMO or content unknown',
            },
          ]
        },
      ],
    };
  }
}
