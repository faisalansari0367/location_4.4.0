import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../constants/index.dart';
import '../../models/polygon_model.dart';

class GeofenceCard extends StatelessWidget {
  final PolygonModel item;
  final bool isSelected;
  final VoidCallback? onTap;
  const GeofenceCard({
    Key? key,
    required this.item,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: kBorderRadius,
        child: AnimatedContainer(
          duration: 250.milliseconds,
          padding: kPadding,
          decoration: BoxDecoration(
            border: _border(item),
            color: isSelected ? item.color.withOpacity(0.3) : Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: context.textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.createdAt == null ? '' : 'On ${MyDecoration.formatDate(item.createdAt!)}',
                        style: context.textTheme.subtitle2?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right_outlined,
                  ),
                ],
              ),
              Gap(10.h),
              Text(
                // MyDecoration.formatDate(item.!createdBy.createdAt),
                'Created By',
                style: context.textTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              Row(
                children: [
                  Text(
                    // MyDecoration.formatDate(item.!createdBy.createdAt),
                    '${item.createdBy!.firstName!} ${item.createdBy!.lastName!}',
                    style: context.textTheme.subtitle2?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Spacer(),
                  Expanded(
                    child: Text(
                      // MyDecoration.formatDate(item.!createdBy.createdAt),
                      item.updatedAt == null ? '' : 'Last Update ${MyDecoration.formatDate(item.updatedAt!)}',
                      textAlign: TextAlign.end,
                      style: context.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Border _border(PolygonModel item) {
    return Border(
      left: BorderSide(
        color: item.color,
        width: 5,
      ),
      top: BorderSide(
        color: Colors.grey.shade300,
        // width: 7,
      ),
      right: BorderSide(
        color: Colors.grey.shade300,
      ),
      bottom: BorderSide(
        color: Colors.grey.shade300,
      ),
    );
  }
}
