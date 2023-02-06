import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class PicDetailsView extends StatelessWidget {
  final PicModel model;
  const PicDetailsView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(model.pic),
      ),
      body: SingleChildScrollView(
        padding: kPadding,
        child: AutoSpacing(
          // padding: kPadding,
          children: [
            row(
              children: [
                _column(context, Strings.pic, model.pic),
                _column(context, Strings.city, model.city),
              ],
            ),
            row(
              children: [
                _column(context, Strings.company, model.company),
                _column(
                  context,
                  Strings.countryOfResidency,
                  model.countryOfResidency,
                ),
              ],
            ),
            row(
              children: [
                _column(
                  context,
                  Strings.ngr,
                  model.ngr,
                ),
                _column(
                  context,
                  Strings.owner,
                  model.owner,
                ),
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
                  Strings.state,
                  model.state,
                ),
              ],
            ),
            row(
              children: [
                _column(
                  context,
                  Strings.postCode,
                  model.postcode.toString(),
                ),
                _column(
                  context,
                  Strings.postCode,
                  model.species.join(', '),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget row({required List<Widget> children}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((e) => Expanded(flex: 3, child: e)).toList(),
    );
  }

  Widget _column(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 108, 108, 108),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 44, 44, 44),
          ),
        )
      ],
    );
  }
}
