import 'package:background_location/extensions/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/my_decoration.dart';
import 'animations/my_slide_animation.dart';

class MyElevatedButton extends StatefulWidget {
  final Widget? child;
  final String? text;
  final Color? color;
  final bool isLoading;
  final Future<void> Function()? onPressed;
  final EdgeInsets? padding;
  final double? width;
  const MyElevatedButton({
    Key? key,
    this.child,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.text,
    this.padding,
    this.color,
  }) : super(key: key);

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

  void onTap() async {
    if (widget.onPressed != null) {
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
    return SizedBox(
      width: widget.width ?? double.infinity,
      child: ElevatedButton(
        onPressed: !isLoading ? onTap : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: widget.color ?? theme.primaryColor,
          // minimumSize: Size(70.width, 6.height),
          side: MyDecoration.inputBorder.borderSide,
          shape: const StadiumBorder(),
          shadowColor: theme.primaryColor.withOpacity(0.5),
          alignment: Alignment.center,
          padding: widget.padding ?? const EdgeInsets.fromLTRB(20, 15, 12, 15),
          onPrimary: theme.textTheme.subtitle1!.color,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        child: MySlideAnimation(
          // key: UniqueKey(),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Loading...'),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  ],
                )
              : widget.child ??
                  Text(
                    widget.text!,
                    style: context.textTheme.button?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      // fontSize: 4.width,
                      fontSize: 3.5.width,
                    ),
                  ),
        ),
      ),
    );
  }
}
