import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyElevatedButton extends StatefulWidget {
  final Widget? child;
  final String? text;
  final Color? color;
  final bool isLoading;
  final Future<void> Function()? onPressed;
  final double? height;
  final EdgeInsets? padding;
  final double? width;
  const MyElevatedButton({
    super.key,
    this.child,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.text,
    this.padding,
    this.color,
    this.height,
  });

  @override
  State<MyElevatedButton> createState() => _MyElevatedButtonState();
}

class _MyElevatedButtonState extends State<MyElevatedButton> {
  bool isLoading = false;

  void setLoading(bool value) {
    if (!mounted) return;
    setState(() {
      isLoading = value;
    });
  }

  Future<void> onTap() async {
    if (widget.onPressed != null) {
      FocusScope.of(context).requestFocus(FocusNode());
      setLoading(true);

      await widget.onPressed!();
      setLoading(false);
    }
  }

  @override
  void initState() {
    isLoading = widget.isLoading;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyElevatedButton oldWidget) {
    final hasChange = widget.isLoading != oldWidget.isLoading;
    if (hasChange) {
      setLoading(widget.isLoading);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedButton(
      onTap: !isLoading ? onTap : null,
      child: AnimatedContainer(
        duration: 200.milliseconds,
        alignment: Alignment.center,
        width: widget.width ?? double.infinity,
        constraints: BoxConstraints(
          minHeight: 50.h,
          minWidth: 64.w,
          maxHeight: widget.height ?? 50.h,
        ),
        decoration: BoxDecoration(
          color: isLoading ? theme.disabledColor.withOpacity(0.10) : widget.color ?? theme.primaryColor,
          borderRadius: MyDecoration.inputBorderRadius,
          // boxShadow: isLoading
          //     ? []
          //     : [
          //         BoxShadow(
          //           color: (widget.color ?? theme.primaryColor).withOpacity(0.3),
          //           blurRadius: 2,
          //           offset: Offset(0, 5),
          //         ),
          //       ],
        ),
        child: AnimationConfiguration.synchronized(
          child: ScaleAnimation(
            curve: kCurve,
            scale: 0.5,
            // key: ValueKey(isLoading),s
            child: FadeInAnimation(
              curve: kCurve,
              child: isLoading ? _showLoading() : widget.child ?? _showText(context),
            ),
          ),
        ),
      ),
    );
  }

  // ElevatedButton _elevatedButton(ThemeData theme, BuildContext context) {
  //   return ElevatedButton(
  //     onPressed: !isLoading ? onTap : null,
  //     style: ElevatedButton.styleFrom(
  //       onSurface: Colors.white,

  //       elevation: 0,
  //       primary: widget.color ?? theme.primaryColor,
  //       // minimumSize: Size(70.width, 6.height),
  //       side: MyDecoration.inputBorder.borderSide,
  //       shape: const StadiumBorder(),
  //       shadowColor: theme.primaryColor.withOpacity(0.5),
  //       alignment: Alignment.center,
  //       padding: widget.padding ?? EdgeInsets.fromLTRB(20.w, 15.h, 12.w, 15.h),
  //       onPrimary: theme.textTheme.subtitle1!.color,
  //       textStyle: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     child: MySlideAnimation(
  //       key: ValueKey(isLoading),
  //       child: isLoading ? _showLoading() : widget.child ?? _showText(context),
  //     ),
  //   );
  // }

  Text _showText(BuildContext context) {
    return Text(
      widget.text!,
      style: context.textTheme.button?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 3.5.width,
      ),
    );
  }

  Row _showLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Loading...',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 3.5.width,
          ),
        ),
        const SizedBox(width: 15),
        SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 3.r),
        )
      ],
    );
  }
}
