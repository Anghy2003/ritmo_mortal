import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ritmo_mortal_application/ui/tutorial/Tutopag1.dart';

// Importar efectos de lluvia y rayos
import 'package:ritmo_mortal_application/ui/widgets/rain_effect.dart';

import 'package:ritmo_mortal_application/ui/widgets/rhythm_indicador.dart';
import 'package:ritmo_mortal_application/ui/widgets/seleccionarjugador.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _iniciarMusicaFondo();
  }

  void _iniciarMusicaFondo() async {
    _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer.setLoopMode(LoopMode.one); // repetir
      await _audioPlayer.setAsset('assets/sonidos/fondomenu.mp3');
      _audioPlayer.play();
    } catch (e) {
      debugPrint('Error al reproducir audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'lib/assets/imagenes/barquitoIA.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Efecto de lluvia
          const RainEffect(),

          // Efecto de rayos
          const LightningEffect(),

          Padding(
            padding: const EdgeInsets.only(left: 45, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DEADLY RHYTHM',
                  style: TextStyle(
                    fontFamily: 'JollyLodger',
                    fontSize: 70,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 18),
                MenuButton(texto: 'JUGAR', audioPlayer: _audioPlayer),
                const SizedBox(height: 18),
                MenuButton(texto: 'TUTORIAL', audioPlayer: _audioPlayer),
                const SizedBox(height: 18),
                MenuButton(texto: 'SALIR', audioPlayer: _audioPlayer),
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
  final AudioPlayer audioPlayer;

  const MenuButton({
    super.key,
    required this.texto,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await audioPlayer.stop();

        if (texto == 'SALIR') {
          SystemNavigator.pop();
        } else if (texto == 'TUTORIAL') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  Tutopag()),
          );
        } else if (texto == 'JUGAR') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SeleccionJugadoresScreen()),
          );
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
