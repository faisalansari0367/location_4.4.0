import 'package:bioplus/constants/constans.dart';
import 'package:bioplus/constants/my_decoration.dart';
import 'package:bioplus/widgets/animations/animated_button.dart';
import 'package:bioplus/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ValidateLpa extends StatefulWidget {
  const ValidateLpa({super.key});

  @override
  State<ValidateLpa> createState() => _ValidateLpaState();
}

class _ValidateLpaState extends State<ValidateLpa> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Gap gap = Gap(10.h);
    return Container(
      decoration: MyDecoration.decoration(),
      padding: kPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Lpa Details',
                style: context.textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              AnimatedButton(
                scale: 0.8,
                onTap: Get.back,
                child: Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.clear),
                ),
              ),
            ],
          ),
          gap,
          gap,
          const MyTextField(hintText: 'LPA Username'),
          gap,
          const MyTextField(hintText: 'LPA Password'),
          gap,
          const MyElevatedButton(text: 'Validate'),
        ],
      ),
    );
  }
}
