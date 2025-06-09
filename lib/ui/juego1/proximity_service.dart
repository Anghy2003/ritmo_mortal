import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityService {
  StreamSubscription<int>? _subscription;

  /// Inicia el listener del sensor de proximidad
  void startListening(Function(bool) onChange) {
    try {
      _subscription = ProximitySensor.events.listen((int event) {
        onChange(event > 0);
      });
    } catch (e) {
      print('Error iniciando sensor: $e');
    }
  }

  /// Detiene el listener del sensor
  void stopListening() {
    _subscription?.cancel();
  }

  /// Verifica si el sensor de proximidad
  Future<bool> isSensorAvailable() async {
    try {
      final testSubscription = ProximitySensor.events.listen((_) {});
      await Future.delayed(Duration(milliseconds: 100));
      await testSubscription.cancel();
      return true;
    } catch (e) {
      print('Sensor no disponible: $e');
      return false;
    }
  }
}
