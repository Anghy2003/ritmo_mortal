import 'package:flutter/material.dart';

class Tutopag5 extends StatelessWidget {
  const Tutopag5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo principal
          SizedBox.expand(
            child: Image.asset(
              'lib/assets/imagenes/barquitoIA.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Recuadro exterior blanco translúcido
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 850),
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
              ),
              padding: const EdgeInsets.all(6),
              child: Container(
                color: Colors.black.withOpacity(0.85),
                padding: const EdgeInsets.all(14),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recuadro interno oscuro con imagen y logo
                          Container(
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Fondo interno: barco otra vez
                                Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    'lib/assets/imagenes/barquitoIA.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 160,
                                  ),
                                ),
                                // Contenido encima
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 8),
                                    Image.asset(
                                      'lib/assets/imagenes/logo.png',
                                      height: 70,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'CAPITÁN',
                                      style: TextStyle(
                                        fontFamily: 'JollyLodger',
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        'TU OBJETIVO ES SUPERAR RETOS RÍTMICOS',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'JollyLodger',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Texto principal sin saltos de línea
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Has despertado en un navío maldito. Eres el único con sentido del ritmo capaz de liberar el barco de la maldición. Los tambores retumban. Los espíritus acechan. Solo reaccionando al ritmo y superando cada desafío sensorial podrás escapar.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'JollyLodger',
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // VOLVER + puntos
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'VOLVER',
                              style: TextStyle(
                                fontFamily: 'JollyLodger',
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: List.generate(6, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == 0
                                      ? Colors.blue
                                      : Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
