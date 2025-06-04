import 'package:flutter/material.dart';

import 'package:ritmo_mortal_application/ui/widgets/menu.dart'; 

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'lib/assets/imagenes/barquitoIA.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'DEADLY RHYTHM',
                  style: TextStyle(
                    fontFamily: 'JollyLodger',
                    fontSize: 80,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      //rempazamos la pantaña de inciio por la de menu
                      MaterialPageRoute(builder: (context) => const Menu()),
                    );
                  },
                  child: const Text(
                    'Pulsa el click para continuar',
                    style: TextStyle(
                      fontFamily: 'JollyLodger',
                      fontSize: 35,
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
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
      ),
    );
  }
}
