// import 'package:api_repo/api_repo.dart';
// import 'package:bioplus/constants/index.dart';
// import 'package:bioplus/ui/cvd_form/cubit/cvd_cubit.dart';
// import 'package:bioplus/ui/cvd_form/models/buyer_details_model.dart';
// import 'package:bioplus/ui/cvd_form/models/cvd_form_data.dart';
// import 'package:bioplus/ui/cvd_form/widgets/common_buttons.dart';
// import 'package:bioplus/ui/cvd_form/widgets/cvd_textfield.dart';
// import 'package:bioplus/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';

// import '../../../helpers/validator.dart';
// import '../../../widgets/text_fields/text_formatters/input_formatters.dart';

// class CommonPage extends StatefulWidget {
//   final List<CvdFormData> data;
//   final bool fillData;
//   const CommonPage({Key? key, required this.data, this.fillData = true}) : super(key: key);

//   @override
//   State<CommonPage> createState() => _CommonPageState();
// }

// class _CommonPageState extends State<CommonPage> {
//   UserData? userData;
//   // final vendorDetails = VendorDetailsModel();
//   final formKey = GlobalKey<FormState>();
//   final formData = {};
//   @override
//   void initState() {
//     if (widget.fillData) userData = context.read<Api>().getUserData();
//     final cubit = context.read<CvdCubit>();
//     final stepName = cubit.stepNames.elementAt(cubit.state.currentStep);
//     final map = cubit.map[stepName] ?? {};
//     formData.addAll(map);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Form(
//           key: formKey,
//           child: ListView.separated(
//             separatorBuilder: (context, index) => Gap(15.h),
//             itemBuilder: _itemBuilder,
//             itemCount: widget.data.length,
//             primary: false,
//             shrinkWrap: true,
//           ),
//         ),
//         CommonButtons(
//           onContinue: () {
//             final isValidated = formKey.currentState!.validate();
//             if (isValidated) {
//               final cubit = context.read<CvdCubit>();
//               cubit.addFormData(formData);
//               cubit.changeCurrent(cubit.state.currentStep + 1);
//             }
//           },
//         ),
//         Gap(50.h),
//       ],
//     );
//   }

//   String? getValue(BuildContext context, String name) {
//     final data = context.read<Api>().getUserData();
//     final map = {};
//     print(name.toCamelCase);
//     switch (name.toCamelCase) {
//       case 'name':
//         if (map.isEmpty) return '';
//         return map['firstName'] ?? '' ' ' + map['lastName'];
//       case 'propertyIdentificationCode(pic)':
//         return data?.pic;

//       default:
//         return map[name.toCamelCase];
//     }
//   }

//   Widget _itemBuilder(BuildContext context, int index) {
//     final item = widget.data.elementAt(index);
//     switch (item.name.toCamelCase) {
//       case 'propertyIdentificationCode(pic)':
//         _onChanged(item.name, userData?.pic ?? '');
//         return CvdTextField(
//           name: item.name,
//           // textCapitalization: TextCapitalization.characters,
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           textInputType: TextInputType.number,
//           validator: Validator.pic,
//           maxLength: 8,
//           // value: userData?.pic,
//           value: formData[item.name] ?? '',
//           onChanged: (s) => _onChanged(item.name, s),
//         );
//       case 'tel':
//         _onChanged(item.name, userData?.phoneNumber ?? '');
//         return PhoneTextField(
//           controller: TextEditingController(text: userData?.phoneNumber),

//           // name: item.name,

//           // value: userData?.phoneNumber,
//           onChanged: (p, c) => _onChanged(item.name, p),
//         );

//       case 'town':
//         _onChanged(item.name, userData?.town ?? '');
//         return CvdTextField(
//           inputFormatters: [CapitalizeAllInputFormatter()],
//           name: item.name,
//           value: userData?.town,
//           onChanged: (s) => _onChanged(item.name, s),
//         );

//       case 'email':
//         _onChanged(item.name, userData?.email ?? '');
//         return EmailField(
//           // name: item.name,
//           // inputFormatters: [LowerCaseTextFormatter()],
//           // validator: Validator.email,
//           // value: userData?.email,
//           controller: TextEditingController(text: userData?.email),
//           onChanged: (s) => _onChanged(item.name, s),
//         );

//       case 'name':
//         var data = '';
//         if (userData?.firstName == null && userData?.lastName == null) {
//         } else {
//           data = '${userData!.firstName!} ${userData!.lastName!}';
//         }
//         _onChanged(item.name, data);
//         return CvdTextField(
//           name: item.name,
//           value: data,
//           onChanged: (s) => _onChanged(item.name, s),
//         );
//       case 'nationalGrowerRegistration(ngr)No':
//         _onChanged('ngr', userData?.ngr ?? '');
//         return CvdTextField(
//           name: item.name,
//           value: userData?.ngr,
//           onChanged: (s) => _onChanged(item.name, s),
//         );
//       case 'address':
//         _onChanged(item.name, getAddress());
//         return CvdTextField(
//           name: item.name,
//           value: getAddress(),
//           onChanged: (s) => _onChanged(item.name, s),
//         );

//       case 'fax':
//         return CvdTextField(
//           name: item.name,
//           validator: (s) => null,
//           onChanged: (s) => _onChanged(item.name, s),
//         );

//       default:
//         return CvdTextField(
//           name: item.name,
//           value: formData[item.name] ?? '',
//           // value: ,
//           onChanged: (s) => _onChanged(item.name, s),
//         );
//     }
//   }

//   String getAddress() {
//     var address = '';
//     address += userData?.street ?? '';
//     address += ' ';
//     address += userData?.town ?? '';
//     address += ' ';
//     address += userData?.state ?? '';
//     address += ' ';

//     if (userData?.postcode != null) address += userData!.postcode!.toString();

//     return address.trim();
//   }

//   void _onChanged(String key, String value) {
//     // final cubit = context.read<CvdCubit>();
//     // final stepName = cubit.stepNames.elementAt(cubit.state.currentStep);
//     // final map = cubit.map[stepName] ?? {};
//     formData.addAll({key: value});
//     // cubit.map[stepName] = map;
//     // cubit.map.addAll({key: value});
//     // print(cubit.map);
//   }
// }
