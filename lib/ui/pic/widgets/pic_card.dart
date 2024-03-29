// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PicCard extends StatelessWidget {
  final PicModel picModel;
  final VoidCallback? onTap;
  const PicCard({super.key, required this.picModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        // borderRadius: kBorderRadius,
        child: AnimatedContainer(
          duration: 250.milliseconds,
          padding: kPadding,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: kBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        picModel.pic,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        picModel.propertyName ?? '',
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_outlined,
                  ),
                ],
              ),
              Gap(10.h),
              if (picModel.owner != null &&
                  picModel.company?.isNotEmpty == true) ...[
                Row(
                  children: [
                    _column(context, 'Owner', picModel.owner),
                    const Spacer(),
                    _column(context, 'Company', picModel.company),
                  ],
                ),
                Gap(10.h),
              ],
              _column(
                context,
                'Address',
                '${picModel.street}, ${picModel.town}, ${picModel.state}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _column(BuildContext context, String title, String? value) {
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
          value ?? '',
          textAlign: TextAlign.end,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 44, 44, 44),
          ),
        )
      ],
    );
  }

  Border _border() {
    return Border(
      left: BorderSide(
        color: Colors.grey.shade300,
        width: 5,
      ),
      top: BorderSide(
        color: Colors.grey.shade300,
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
