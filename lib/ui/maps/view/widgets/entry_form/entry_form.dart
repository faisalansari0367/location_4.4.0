import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/forms/view/entry_zone_form.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../../widgets/my_appbar.dart';
import '../../../../forms/view/form2.dart';
import 'cubit/entry_form_cubit.dart';

class EntryForm extends StatefulWidget {
  final PolygonModel polygonModel;
  const EntryForm({Key? key, required this.polygonModel}) : super(key: key);

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  late EntryFormCubit cubit;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    cubit = EntryFormCubit(api: context.read<Api>(), polygon: widget.polygonModel, mapsApi: context.read<MapsRepo>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // cubit = EntryFormCubit(context.read<Api>());
    return ChangeNotifierProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: MyAppBar(
          title: Text('Zone Entry Form'),
        ),
        body: SingleChildScrollView(
          // padding: kPadding,
          child: Consumer<EntryFormCubit>(
            builder: (context, state, child) {
              if (state.state.isLoading) {
                return SizedBox(
                  height: 45.height,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state.state.isFirstForm) {
                return Form1(
                  form1: state.state.forms.first,
                  onSubmit: (s) => cubit.submitFormData(s),
                );
              } else {
                return Form2(
                  form2: state.state.forms[1],
                  onSubmit: (s) => cubit.submitFormData(s),
                );
              }
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    MyListview(
                      isLoading: state.state.isLoading,
                      shrinkWrap: true,
                      // padding: kPadding,
                      data: state.state.formData,
                      itemBuilder: (context, index) {
                        final item = state.state.formData[index];
                        return item.fieldWidget;
                      },
                    ),
                    Gap(10.h),
                    if (!state.state.isLoading)
                      MyElevatedButton(
                        text: 'Submit',
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          await cubit.onPressed();
                        },
                      )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
