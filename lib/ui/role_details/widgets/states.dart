import 'package:background_location/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class States extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const States({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final states = ['ACT', 'VIC', 'NSW', 'QLD', 'NT', 'WA', 'TAS', 'SA'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          Strings.selectState,
          style: context.textTheme.headline6?.copyWith(),
        ),
        const SizedBox(height: 10),
        ...states
            .map(
              (e) => ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                onTap: () {
                  Get.back();
                  onChanged(e);
                },
                title: Text(
                  e,
                  style: context.textTheme.subtitle1?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
