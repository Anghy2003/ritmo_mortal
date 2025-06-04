import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ritmo_mortal_application/ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//define la orientacion dle ceular adaptada  ala app
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Inicio());
  }
}
