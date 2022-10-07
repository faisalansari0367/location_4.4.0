import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RolesSheet extends StatelessWidget {
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String title;

  const RolesSheet({Key? key, required this.onChanged, this.options = const [], required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: context.textTheme.headline6?.copyWith(
              // fontWeight: FontWeight.w500,
              // color: Colors.black,
              ),
        ),
        const SizedBox(height: 10),
        ...options
            .map((e) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(),
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
                ),)
            .toList()
      ],
    );
  }
}
