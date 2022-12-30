import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/cvd_form/cubit/cvd_cubit.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/download_button/download_button.dart';
import 'package:bioplus/widgets/signature/signature_widget.dart';
import 'package:bioplus/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../constants/index.dart';
import '../../../widgets/dialogs/dialogs.dart';

class SelfDeclaration extends StatefulWidget {
  const SelfDeclaration({Key? key}) : super(key: key);

  @override
  State<SelfDeclaration> createState() => _SelfDeclarationState();
}

class _SelfDeclarationState extends State<SelfDeclaration> {
  List<String> data = [];
  String? signature;
  TextEditingController nameController = TextEditingController();
  TextEditingController orgController = TextEditingController();

  String name = '', org = '';

  @override
  void initState() {
    orgController = TextEditingController(text: context.read<Api>().getUserData()?.company);
    context.read<CvdCubit>().setOrgName(orgController.text);
    nameController = TextEditingController(text: getName());
    _init();
    super.initState();
  }

  TextStyle get style => TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16.w,
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // stream: null,
      builder: (context, constraints) {
        return Column(
          children: [
            // Gap(20.h),
            MyTextField(
              hintText: 'Name',
              controller: nameController,

              // value: getName(),

              textCapitalization: TextCapitalization.characters,
              onChanged: (s) => setState(() {
                name = s;
              }),
            ),
            Gap(10.h),
            MyTextField(
              hintText: 'Organization',
              controller: orgController,
              textCapitalization: TextCapitalization.characters,
              onChanged: (s) {
                setState(() {
                  context.read<CvdCubit>().setOrgName(s);
                  org = s;
                });
              },
            ),
            Gap(30.h),

            Row(
              children: [
                const Icon(Icons.info, color: Colors.red),
                Gap(5.w),
                Text(
                  'Please read below points carefully',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16.w,
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: style,
                  text: 'I ',
                  children: [
                    TextSpan(text: nameController.text.isEmpty ? '____' : nameController.text),
                    const TextSpan(text: ' of '),
                    TextSpan(text: orgController.text.isEmpty ? '____' : orgController.text),
                    const TextSpan(text: ' declare that:'),
                  ],
                ),
              ),
            ),
            Gap(10.h),
            AutoSpacing(
              // removeLast: true,
              spacing: const Divider(),
              // startSpacing: Divider(),
              children: [
                ...data.map((e) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.indexOf(e) + 1}. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // color: Colors.grey,
                          fontSize: 16.w,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.trim(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.w,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            Gap(20.h),
            SignatureWidget(
              signature: context.read<CvdCubit>().signature,
              onChanged: (s) {
                context.read<CvdCubit>().setSignature(s);
                setState(() {});
              },
            ),
            Gap(20.h),

            MyDateField(
              label: 'Date',
              date: DateTime.now().toIso8601String(),
            ),
            // if (signature != null)
            //   Positioned(
            //     right: 0,
            //     bottom: 0,
            //     child: Padding(
            //       padding: EdgeInsets.all(10),
            //       child: Text(
            //         'Date: ${MyDecoration.formatDate(DateTime.now())}',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18.w,
            //         ),
            //       ),
            //     ),
            //   )

            Gap(20.h),
            BlocBuilder<CvdCubit, CvdState>(
              builder: (context, state) {
                final cubit = context.read<CvdCubit>();
                // return LimitedBox(
                //   // height: 50.h,
                //   maxHeight: 100,
                //   maxWidth: 80,
                //   child: SizedBox(
                //     child: DownloadButton(
                //       controller: cubit.cvdDownloadController,
                //       buttonText: 'Submit',
                //       padding: const EdgeInsets.all(15),
                //     ),
                //   ),
                // );
                return MyElevatedButton(
                  // isLoading: state.isLoading,
                  text: 'Submit',
                  onPressed: () async {
                    final cubit = context.read<CvdCubit>();
                    if (cubit.signature == null) {
                      DialogService.showDialog(
                        child: NoSignatureFound(
                          message: 'Please sign the declaration',
                          buttonText: 'Ok',
                          onTap: () async {
                            Get.to(
                              () => CreateSignature(
                                onDone: (s) {
                                  if (s == null) return;
                                  cubit.setSignature(s);
                                  Get.back();
                                },
                              ),
                            );
                          },
                        ),
                      );
                      // return;
                    } else {
                      await cubit.submitForm();
                    }
                  },
                );
              },
            ),
            Gap(50.h),
          ],
        );
      },
    );
  }

  String getName() {
    final userData = context.read<Api>().getUserData();
    var data = '';
    if (userData?.firstName == null && userData?.lastName == null) {
    } else {
      data = userData!.fullName;
    }
    return data;
  }

  void _init() async {
    final json = await DefaultAssetBundle.of(context).loadString('assets/json/declaration_form.json');
    data = List<String>.from(jsonDecode(json)['conditions']);
    setState(() {});
  }
}
