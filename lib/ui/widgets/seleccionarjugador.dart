import 'package:flutter/material.dart';

import 'package:ritmo_mortal_application/ui/level1_screen.dart';

class SeleccionJugadoresScreen extends StatelessWidget {
  const SeleccionJugadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo del barco
          Positioned.fill(
            child: Image.asset(
              'lib/assets/imagenes/barquitoIA.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Capa semi-transparente
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),

          // Contenido principal
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '< EN LÍNEA >',
                  style: TextStyle(
                    fontFamily: 'JollyLodger',
                    fontSize: 36,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 5, color: Colors.red)],
                  ),
                ),
                SizedBox(height: 20),

                // Sección de opciones
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _opcionJugador(
                        context,
                        titulo: '1Persona',
                        imagen: 'lib/assets/imagenes/barquitoIA.jpg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JuegoNivel1(numeroJugadores: 1),
                            ),
                          );
                        },
                      ),
                      _opcionJugador(
                        context,
                        titulo: '2Personas',
                        imagen: 'lib/assets/imagenes/barquitoIA.jpg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JuegoNivel1(numeroJugadores: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Botón volver
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'VOLVER',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'JollyLodger',
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _opcionJugador(BuildContext context,
      {required String titulo,
      required String imagen,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'JollyLodger',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                image: AssetImage(imagen),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
