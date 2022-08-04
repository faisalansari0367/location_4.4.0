import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ResponsiveSize on num {
  double get height => (this / 100) * 1.sh;
  double get width => (this / 100) * 1.sw;
}
