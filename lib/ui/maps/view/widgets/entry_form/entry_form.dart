import 'package:api_repo/api_repo.dart';
import 'package:background_location/theme/color_constants.dart';
import 'package:background_location/ui/forms/view/forms_page.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cubit/entry_form_cubit.dart';
import 'cubit/entry_from_state.dart';

class EntryForm extends StatefulWidget {
  final PolygonModel polygonModel;
  const EntryForm({Key? key, required this.polygonModel}) : super(key: key);

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  late EntryFormCubit cubit;
  @override
  void initState() {
    cubit = EntryFormCubit(api: context.read<Api>(), polygon: widget.polygonModel, mapsApi: context.read<MapsRepo>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // cubit = EntryFormCubit(context.read<Api>());
    return Scaffold(
      // appBar: MyAppBar(
      //   title: Text('Zone Entry Form'),
      // ),
      body: Container(
        child: BlocConsumer<EntryFormCubit, EntryFormState>(
          listener: (context, state) => {},
          bloc: cubit,
          builder: (context, state) {
            return FormsPage(
              title: 'Entry zone form',
              questions: state.questions,
              onSubmit: (s) {
                cubit.getFormData(s);
                cubit.onPressed();
              },
            );
            // return SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       MyListview(
            //         isLoading: state.isLoading,
            //         onRetry: cubit.getFormQuestions,
            //         shrinkWrap: true,
            //         padding: kPadding,
            //         data: state.questions,
            //         itemBuilder: (context, index) {
            //           final question = state.questions.elementAt(index);
            //           return Container(
            //             padding: kPadding.copyWith(bottom: 0),
            //             decoration: BoxDecoration(
            //               borderRadius: kBorderRadius,
            //               border: Border.all(
            //                 color: Colors.grey.shade300,
            //               ),
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Text(
            //                   question.trim(),
            //                   style: TextStyle(
            //                     color: Colors.grey.shade800,
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 16.h,
            //                   ),
            //                 ),
            //                 Gap(10.h),
            //                 Row(
            //                   children: [
            //                     _radioButton(_value(state, question), true, 'Yes', question),
            //                     Gap(30.w),
            //                     _radioButton(_value(state, question), false, 'No', question),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //       Padding(
            //         padding: kPadding,
            //         child: MyElevatedButton(
            //           text: 'Submit',
            //           onPressed: () async => cubit.onPressed(),
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          },
        ),
      ),
    );
  }

  bool? _value(EntryFormState state, String question) {
    final hasKey = state.questionAnswers.containsKey(question);
    return hasKey ? _getBoolValue(state.questionAnswers[question]!) : null;
  }

  Container _radioButton(bool? selectedValue, bool value, String text, String question) {
    return Container(
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.h,
              color: Colors.grey.shade600,
            ),
          ),
          Radio<bool>(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value,
            groupValue: selectedValue,
            fillColor: MaterialStateProperty.all(kPrimaryColor),
            onChanged: (s) => cubit.setQuestionValue(question, s! ? 'yes' : 'no'),
          ),
        ],
      ),
    );
  }

  bool _getBoolValue(String s) => s == 'yes' ? true : false;
}
