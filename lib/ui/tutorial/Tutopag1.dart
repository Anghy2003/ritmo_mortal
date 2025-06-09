import 'package:flutter/material.dart';

// Importa el efecto de lluvia
import 'package:ritmo_mortal_application/ui/widgets/rain_effect.dart';

class Tutopag extends StatefulWidget {
  const Tutopag({super.key});

  @override
  State<Tutopag> createState() => _TutopagState();
}

class _TutopagState extends State<Tutopag> {
 final List<String> tutorialTexts = const [
  'Has despertado en un navío maldito. Eres el único con sentido del ritmo capaz de liberar el barco de la maldición. Los tambores retumban y los espíritus acechan. Solo reaccionando al ritmo y superando cada desafío podrás escapar.',

  '“El código está en el ritmo, pirata...”. Para avanzar, debes mover tu mano al compás, detectando el peligro y la fortuna en cada movimiento. Recuerda: la música guía a los vivos, la sombra a los condenados.',

  '“No es el oro lo que nos hace libres, sino el pulso del corazón...”. Acércate al sensor para salvar lo valioso y aleja la mano para evitar la maldición. Tu reflejo y velocidad decidirán el destino final del barco maldito.',

  '“Solo un verdadero pirata puede desafiar al Capitán Sombra...”. Mantente atento, aumenta tu ritmo, y no permitas que el mal te alcance. La victoria está al alcance de quien domina el juego del viento, la sombra y la oscuridad.',
];


  int pageIndex = 0;

  void _goToNext() {
    if (pageIndex < tutorialTexts.length - 1) {
      setState(() {
        pageIndex++;
      });
    }
  }

  void _goToPrevious() {
    if (pageIndex > 0) {
      setState(() {
        pageIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Efecto de lluvia de fondo
          const RainEffect(),

          // Imagen de fondo con transparencia para que la lluvia se vea
          SizedBox.expand(
            child: Image.asset(
              'lib/assets/imagenes/barquitoIA.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600, minHeight: 600),
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
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
                          Container(
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    'lib/assets/imagenes/barquitoIA.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 160,
                                  ),
                                ),
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
                                        fontSize: 28,
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
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 11),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 23),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                tutorialTexts[pageIndex],
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontFamily: 'JollyLodger',
                                  fontSize: 26,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 90,
                            height: 40,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: const Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'VOLVER',
                                    style: TextStyle(
                                      fontFamily: 'JollyLodger',
                                      fontSize: 23,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _goToPrevious,
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: pageIndex == 0 ? Colors.grey : Colors.white,
                              size: 24,
                            ),
                            tooltip: 'Página anterior',
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: List.generate(4, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == pageIndex ? Colors.blue : Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: _goToNext,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: pageIndex == tutorialTexts.length - 1
                                  ? Colors.grey
                                  : Colors.white,
                              size: 24,
                            ),
                            tooltip: 'Página siguiente',
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
