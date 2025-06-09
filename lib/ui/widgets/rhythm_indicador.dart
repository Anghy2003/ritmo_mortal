import 'dart:async';
import 'package:flutter/material.dart';

class LightningEffect extends StatefulWidget {
  const LightningEffect({super.key});

  @override
  State<LightningEffect> createState() => _LightningEffectState();
}

class _LightningEffectState extends State<LightningEffect> {
  bool _showFlash = false;
  late Timer _flashTimer;

  @override
  void initState() {
    super.initState();
    _startFlashing();
  }

  void _startFlashing() {
    _flashTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _showFlash = true);

      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        setState(() => _showFlash = false);
      });
    });
  }

  @override
  void dispose() {
    _flashTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true, // para no bloquear interacciones
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _showFlash ? 0.8 : 0.0,
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
