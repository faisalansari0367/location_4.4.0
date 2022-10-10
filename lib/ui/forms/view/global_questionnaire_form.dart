import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/forms/widget/add_list.dart';
import 'package:background_location/ui/forms/widget/form_card.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:background_location/widgets/text_fields/time_field.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../models/global_questionnaire_form_model.dart';

class GlobalQuestionnaireForm extends StatefulWidget {
  const GlobalQuestionnaireForm({Key? key}) : super(key: key);

  @override
  State<GlobalQuestionnaireForm> createState() => _GlobalQuestionnaireFormState();
}

class _GlobalQuestionnaireFormState extends State<GlobalQuestionnaireForm> {
  final model = GlobalQuestionnaireFormModel();

  List<String> names = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Strings.declaration),
        elevation: 3.0,
      ),
      body: SingleChildScrollView(
        padding: kPadding,
        child: AutoSpacing(
          children: [
            _card(model.q1),
            _card(model.q2),
            _card(model.q3),
            _card(model.q4),
            // _card(model.q5),
            _addList(model.q5),
            MyDropdownField(
              onChanged: (s) {},
              hintText: 'Risk Rating',
              value: 'Low',
              options: ['Low', 'Medium', 'High'],
            ),
            MyDateField(label: 'Expected departure date'),
            MyTimeField(label: 'Expected departure time'),
            SignatureWidget(
              signature: context.read<Api>().getUserData()?.signature,
            ),

            Container(
              decoration: MyDecoration.decoration(),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: CheckboxListTile(
                title: Text(model.selfDeclaration.question),
                value: model.selfDeclaration.value ?? false,
                onChanged: (s) {
                  setState(() {
                    model.selfDeclaration.value = s;
                  });
                },
              ),
            ),
            // Container(
            //   decoration: MyDecoration.decoration(),
            //   padding: EdgeInsets.symmetric(
            //     // horizontal: kPadding.left.w,
            //     vertical: kPadding.top.h,
            //   ),
            //   child: Row(
            //     children: [
            //       //

            //       // declaration

            //       // Expanded(
            //       //   child: Text(
            //       //     'I declare that the animals/products I am transporting are accompanied by correct movement documentation.',
            //       //     // style: context.textTheme.headline6,
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _addList(QuestionData data) {
    return AnimatedSize(
      duration: 500.milliseconds,
      curve: Curves.easeInOut,
      child: Container(
        decoration: MyDecoration.decoration(),
        // padding: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            Container(
              decoration: MyDecoration.decoration(),
              child: QuestionCard(
                question: data.question,
                selectedValue: data.value,
                onChanged: (s) async {
                  if (s.toLowerCase() == 'yes') {
                    // final result = await DialogService.showDialog(
                    //   child: DialogLayout(
                    //     // insetPadding: kPadding,
                    //     child: AddList(),
                    //   ),
                    // );

                    // if (result != null) {
                    // names = result;
                    // }
                  } else {
                    names = [];
                    setState(() {});
                  }
                  data.value = s;
                  setState(() {});
                },
              ),
            ),
            if (data.value == 'yes') ...[
              Gap(10.h),
              AddList(
                onChanged: (value) => names = value,
              ),
              // ListView.separated(
              //   primary: false,
              //   padding: EdgeInsets.symmetric(horizontal: 20.w),
              //   separatorBuilder: (context, index) => const Divider(),
              //   shrinkWrap: true,
              //   itemCount: names.length,
              //   itemBuilder: (context, index) {
              //     return Text(
              //       names[index],
              //       style: TextStyle(
              //         // fontSize: 17.sp,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     );
              //   },
              // ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _card(QuestionData data) {
    return Container(
      decoration: MyDecoration.decoration(),
      child: QuestionCard(
        question: data.question,
        selectedValue: data.value,
        onChanged: (s) => onChanged(data, s),
      ),
    );
  }

  void onChanged(QuestionData data, String value) {
    setState(() {
      data.value = value;
    });
  }
}
