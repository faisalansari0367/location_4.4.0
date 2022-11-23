import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/enum/filter_type.dart';

class FilterWidget extends StatelessWidget {
  final FilterType selectedFilter;
  final ValueChanged<FilterType> onFilterChanged;
  const FilterWidget({super.key, required this.selectedFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Filter by',
          style: TextStyle(
            fontSize: 15.h,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        ...FilterType.values.map(
          (e) {
            final isSelected = e == selectedFilter;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: InputChip(
                selected: isSelected,
                backgroundColor: Colors.grey.shade200,
                selectedColor: context.theme.primaryColor,
                onPressed: () => onFilterChanged.call(e),
                checkmarkColor: isSelected ? Colors.white : Colors.grey,
                label: Text(
                  e.name.replaceAll('_', ' ').capitalize!,
                  style: TextStyle(
                    fontSize: 15.h,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          },
        ).toList()
      ],
    );
  }
}
