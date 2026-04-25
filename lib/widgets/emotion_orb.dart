import 'package:flutter/material.dart';

class EmotionOrb extends StatefulWidget {
  final Color colorStart;
  final Color colorEnd;
  final double size;
  final bool animate;

  const EmotionOrb({
    super.key,
    required this.colorStart,
    required this.colorEnd,
    this.size = 32,
    this.animate = false,
  });

  @override
  State<EmotionOrb> createState() => _EmotionOrbState();
}

class _EmotionOrbState extends State<EmotionOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(EmotionOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && oldWidget.animate) {
      _controller.stop();
      _controller.animateTo(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Transform.scale(
          scale: widget.animate ? _pulse.value : 1.0,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.colorStart, widget.colorEnd],
              ),
            ),
          ),
        );
      },
    );
  }
}
