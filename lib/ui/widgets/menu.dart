import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ritmo_mortal_application/ui/prueba.dart';
import 'package:ritmo_mortal_application/ui/tutorial/tutorial_screen.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'lib/assets/imagenes/barquitoIA.jpg', // usa tu imagen aquí
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'DEADLY RHYTHM',
                  style: TextStyle(
                    fontFamily: 'JollyLodger',
                    fontSize: 70,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 18),
                MenuButton(texto: 'JUGAR'),
                SizedBox(height: 18),
                MenuButton(texto: 'TUTORIAL'),
                SizedBox(height: 18),
                MenuButton(texto: 'SALIR'),
              ],
            ),
          ),
          const Positioned(
            bottom: 16,
            right: 16,
            child: Icon(Icons.help_outline, color: Colors.white, size: 35),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String texto;

  const MenuButton({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (texto == 'SALIR') {
          SystemNavigator.pop(); // Cierra la app
        } else if (texto == 'TUTORIAL') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TutorialScreen()),//nos manda alos tutoriales
          );
        } else if (texto == 'JUGAR') {
         
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProximityDemo()));//nos leva al primer nivel 
          
        }
      },
      child: Text(
        texto,
        style: const TextStyle(
          fontFamily: 'JollyLodger',
          fontSize: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
