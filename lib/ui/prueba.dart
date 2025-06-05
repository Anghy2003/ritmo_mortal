import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityDemo extends StatefulWidget {
  @override
  _ProximityDemoState createState() => _ProximityDemoState();
}

class _ProximityDemoState extends State<ProximityDemo> {
  bool _isNear = false;

  @override
  void initState() {
    super.initState();
    ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = event > 0; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Proximity Sensor Demo")),
      body: Center(
        child: Text(
          _isNear ? "Cerca del sensor" : "Lejos del sensor",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
