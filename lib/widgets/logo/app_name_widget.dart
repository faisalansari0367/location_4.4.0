import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppName extends StatelessWidget {
  final double? fontSize;
  const AppName({Key? key, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w2 = fontSize ?? 60.w;

    return AutoSizeText.rich(
      TextSpan(
        // text: Strings.welcomeTo,
        children: [
          TextSpan(
            text: 'BIO',
            style: TextStyle(
              color: Color(0xff3B4798),
              fontWeight: FontWeight.bold,
              fontSize: w2,
            ),
          ),
          TextSpan(
            text: 'SECURE',
            style: TextStyle(
              color: Color(0xff75B950),
              fontWeight: FontWeight.bold,
              fontSize: w2,
            ),
          ),
        ],
        style: context.textTheme.headline5,
      ),
      maxLines: 1,
    );
  }
}
