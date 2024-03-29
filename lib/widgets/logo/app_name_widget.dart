import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/constants/index.dart';
import 'package:flutter/widgets.dart';

class AppName extends StatelessWidget {
  final double? fontSize;
  const AppName({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final w2 = fontSize ?? 13.width;
    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'BIO',
            style: TextStyle(
              color: const Color(0xff3B4798),
              fontWeight: FontWeight.bold,
              fontSize: w2,
            ),
          ),
          TextSpan(
            text: 'PLUS',
            style: TextStyle(
              color: const Color(0xff75B950),
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
