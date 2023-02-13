import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/add_pic/view/add_pic_page.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PicDetailsView extends StatelessWidget {
  final PicModel model;
  const PicDetailsView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(model.pic),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(
                () => AddPicPage(
                  pic: model,
                  updatePic: true,
                ),
              );
            },
          ),
          Gap(20.h),
        ],
      ),
      body: SingleChildScrollView(
        padding: kPadding,
        child: AutoSpacing(
          children: [
            row(
              children: [
                _column(context, Strings.pic, model.pic),
                _column(
                  context,
                  Strings.ngr,
                  model.ngr,
                ),
              ],
            ),
            row(
              children: [
                _column(context, Strings.company, model.companies),
              ],
            ),
            row(
              children: [
                _column(
                  context,
                  Strings.properyName,
                  model.propertyName,
                ),
                _column(
                  context,
                  Strings.owner,
                  model.owner,
                ),
              ],
            ),
            _column(
              context,
              'Address',
              '${model.street}, ${model.town}, ${model.state}',
            ),
            row(
              children: [
                _column(
                  context,
                  Strings.state,
                  model.state,
                ),
                _column(
                  context,
                  Strings.postCode,
                  model.postcode == null ? '' : model.postcode.toString(),
                ),
              ],
            ),
            _container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.lpaCrdentials,
                    style: context.textTheme.headlineSmall,
                  ),
                  Gap(25.h),
                  _column(
                    context,
                    Strings.lpaUsername,
                    model.lpaUsername,
                    isRow: true,
                  ),
                  Gap(20.h),
                  _column(
                    context,
                    Strings.lpaPassword,
                    model.lpaPassword,
                    isRow: true,
                  ),
                ],
              ),
            ),
            _container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.accreditations,
                    style: context.textTheme.headlineSmall,
                  ),
                  Gap(25.h),
                  _column(
                    context,
                    Strings.msa,
                    model.msaNumber,
                    isRow: true,
                  ),
                  Gap(20.h),
                  _column(
                    context,
                    Strings.nfas,
                    model.nfasAccreditationNumber,
                    isRow: true,
                  ),
                ],
              ),
            ),
            _container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.nlisCredentials,
                    style: context.textTheme.headlineSmall,
                  ),
                  Gap(25.h),
                  _column(
                    context,
                    Strings.nlisUsername,
                    model.nlisUsername,
                    isRow: true,
                  ),
                  Gap(20.h),
                  _column(
                    context,
                    Strings.nlisPassword,
                    model.nlisPassword,
                    isRow: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _container({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget row({required List<Widget> children}) {
    return Row(
      children: children.map((e) => Expanded(flex: 3, child: e)).toList(),
    );
  }

  Widget _column(
    BuildContext context,
    String title,
    String? value, {
    bool isRow = false,
  }) {
    final children = [
      Text(
        title,
        style: context.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 108, 108, 108),
        ),
      ),
      Text(
        value ?? '',
        textAlign: TextAlign.end,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 44, 44, 44),
        ),
      )
    ];

    if (isRow) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
