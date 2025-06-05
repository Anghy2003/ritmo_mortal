import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'dart:async';

class ProximityDemo extends StatefulWidget {
  @override
  _ProximityDemoState createState() => _ProximityDemoState();
}

class _ProximityDemoState extends State<ProximityDemo> {
  bool _isNear = false;
  bool _hasSensor = true;
  StreamSubscription<int>? _subscription;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    try {
      _subscription = ProximitySensor.events.listen((int event) {
        setState(() {
          _isNear = event > 0;
        });
      });
    } catch (e) {
      setState(() {
        _hasSensor = false;
      });
      print("Error verificando el sensor de proximidad: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Proximity Sensor Demo")),
      body: Center(
        child: _hasSensor
            ? Text(
                _isNear ? "Cerca del sensor" : "Lejos del sensor",
                style: const TextStyle(fontSize: 24),
              )
            : const Text(
                "Este dispositivo no tiene un sensor de proximidad.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
      ),
    );
  }
}
