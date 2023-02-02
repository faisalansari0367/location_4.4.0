import 'package:bioplus/constants/constans.dart';
import 'package:bioplus/constants/my_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeclarationFormCard extends StatelessWidget {
  final String question;
  final String? value;
  const DeclarationFormCard({super.key, required this.question, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null) return Container();
    return Container(
      decoration: MyDecoration.decoration(
        shadow: false,
        color: const Color.fromARGB(255, 242, 242, 242),
      ),
      padding: kPadding,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
              fontSize: 16.h,
            ),
          ),
          TextFormField(
            enabled: false,
            initialValue: value,
          ),
        ],
      ),
    );
  }
}
