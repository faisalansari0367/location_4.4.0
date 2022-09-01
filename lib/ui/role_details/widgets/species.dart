import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../constants/constans.dart';

class SpeciesWidget extends StatefulWidget {
  final UserSpecies data;
  const SpeciesWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<SpeciesWidget> createState() => _SpeciesWidgetState();
}

class _SpeciesWidgetState extends State<SpeciesWidget> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Species',
            style: context.textTheme.headline6?.copyWith(
              fontWeight: FontWeight.w600,
              // fontSize: 30.h,
            ),
          ),
          Gap(20.h),
          ...childrens(),
        ],
      ),
    );
  }

  Row _tile(SpeciesData e) {
    return Row(
      children: [
        Container(
          height: 40.r,
          child: CachedNetworkImage(
            imageUrl: e.image!,
          ),
        ),
        Gap(20.w),
        Expanded(
          child: Text(
            e.species ?? '',
            style: TextStyle(
              color: Colors.grey.shade900,
              fontWeight: FontWeight.w600,
              fontSize: 20.h,
            ),
          ),
        ),
        Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: e.value,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          onChanged: (s) {
            setState(() {
              e.value = s;
            });
          },
        ),
      ],
    );
  }

  List<Widget> childrens() {
    final list = <Widget>[];
    for (var item in widget.data.data ?? []) {
      list.add(_tile(item));
      list.add(Divider());
    }
    list.removeLast();
    return list;
  }
}
