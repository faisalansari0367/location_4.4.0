import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/my_decoration.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RoleTag extends StatelessWidget {
  final Color? bgColor;
  const RoleTag({super.key, this.bgColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          MyDecoration.decoration(color: bgColor ?? context.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      child: StreamBuilder<bool>(
        stream: MyConnectivity().connectionStream,
        initialData: true,
        builder: (context, snapshot) {
          final api = context.read<Api>();
          return StreamBuilder<User?>(
            stream: (snapshot.data ?? false) ? api.userStream : api.userStream,
            builder: (context, snapshot) {
              final hasName = ![null, ''].contains(snapshot.data?.role);
              final role = hasName ? snapshot.data?.role : '';
              return Text(
                role ?? '',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: getTextColor(bgColor ?? context.theme.primaryColor),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1.sp,
                  fontSize: 14.sp,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color getTextColor(Color color) {
    int d = 0;

// Counting the perceptive luminance - human eye favors green color...
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5) {
      d = 0; // bright colors - black font
    } else {
      d = 255; // dark colors - white font
    }

    return Color.fromARGB(color.alpha, d, d, d);
  }
}
