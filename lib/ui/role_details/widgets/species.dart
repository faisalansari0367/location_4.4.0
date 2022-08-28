import 'package:api_repo/api_repo.dart';
import 'package:flutter/material.dart';

import '../../../constants/constans.dart';

class SpeciesWidget extends StatelessWidget {
  final UserSpecies data;
  const SpeciesWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: kPadding,
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1,
        ),
      ),
      // child: Column(
      //   children: [
      //     CheckboxListTile(value: value, onChanged: onChanged),
      //   ],
      // ),
    );
  }
}
