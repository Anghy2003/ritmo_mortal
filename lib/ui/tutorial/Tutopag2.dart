import 'package:flutter/material.dart';

class Tutopag2 extends StatelessWidget {
  const Tutopag2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo
        SizedBox.expand(
          child: Image.asset(
            'lib/assets/imagenes/barquitoIA.jpg',
            fit: BoxFit.cover,
          ),
        ),

        // Contenido
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('lib/assets/imagenes/logo.png', height: 120),
                const SizedBox(height: 20),
                const Text(
                  'TUTORIAL',
                  style: TextStyle(
                    fontFamily: 'JollyLodger',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Has despertado en un navío maldito...\n\n'
                  'Eres el único con sentido del ritmo capaz de liberar el barco de la maldición.\n\n'
                  'Los tambores retumban. Los espíritus acechan.\n\n'
                  'Solo reaccionando al ritmo y superando cada desafío sensorial podrás escapar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'JollyLodger',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Indicadores y botón volver
        Positioned(
          bottom: 20,
          left: 20,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'VOLVER',
              style: TextStyle(
                fontFamily: 'JollyLodger',
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
