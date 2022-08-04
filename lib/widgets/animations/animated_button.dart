import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final void Function() onTap;
  const AnimatedButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  static const duration = Duration(milliseconds: 125);

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: duration);
    final animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    final tween = Tween<double>(begin: 1.0, end: 0.97);
    _scale = tween.animate(animation);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();

  void _onTapUp(TapUpDetails details) => _controller.reverse();

  void _onTap() async {
    await _controller.forward();
    await _controller.reverse();

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: _onTap,
      onTapUp: _onTapUp,
      onTapDown: _onTapDown,
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (BuildContext context, Widget? child) {
          return ScaleTransition(
            scale: _scale,
            child: child,
          );
        },
      ),
    );
  }
}
