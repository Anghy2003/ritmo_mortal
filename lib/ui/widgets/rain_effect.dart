import 'dart:math';
import 'package:flutter/material.dart';

class RainEffect extends StatefulWidget {
  const RainEffect({super.key});

  @override
  State<RainEffect> createState() => _RainEffectState();
}

class _RainEffectState extends State<RainEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Offset> _drops = [];
  final int _numDrops = 150;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _numDrops; i++) {
      _drops.add(Offset(_rand.nextDouble(), _rand.nextDouble()));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          size: size,
          painter: RainPainter(_drops, size),
        );
      },
    );
  }
}

class RainPainter extends CustomPainter {
  final List<Offset> drops;
  final Size size;
  final Random rand = Random();

  RainPainter(this.drops, this.size);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    for (final drop in drops) {
      final dx = drop.dx * size.width;
      final dy = (drop.dy * size.height + DateTime.now().millisecond * 0.4) % size.height;
      canvas.drawLine(Offset(dx, dy), Offset(dx, dy + 10), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
