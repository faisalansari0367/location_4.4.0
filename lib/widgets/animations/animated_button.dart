import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? scale;
  const AnimatedButton({
    super.key,
    required this.child,
    this.onTap,
    this.scale,
  });

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
    final tween = Tween<double>(begin: 1, end: widget.scale ?? 0.97);
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

  Future<void> _onTap() async {
    await _controller.forward();
    await _controller.reverse();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // key: ValueKey(widget.child),
      onTap: _onTap,
      onTapUp: _onTapUp,
      onTapDown: _onTapDown,
      onTapCancel: _controller.reverse,
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
