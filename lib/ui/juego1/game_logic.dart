import 'dart:async';
import 'dart:math';
import 'package:just_audio/just_audio.dart';

class GameLogicDosJugadores {
  final List<Map<String, dynamic>> objetos = [
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/cofre.png'},
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/pirata.png'},
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/copapirata.png'},
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/gorropirata.png'},
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/mapa.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/alarma.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/calaveraroja.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/coparoja.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/carro.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/pelota.png'},
  ];

  final Random random = Random();
  final AudioPlayer monedaPlayer = AudioPlayer();
  final AudioPlayer errorPlayer = AudioPlayer();

  Map<String, dynamic>? objetoActual;
  int jugadorActual = 1; // 1 o 2

  Map<int, int> puntajes = {1: 0, 2: 0};
  Map<int, int> combos = {1: 0, 2: 0};
  Map<int, bool> escudoActivo = {1: false, 2: false};
  Map<int, bool> dobleOro = {1: false, 2: false};

  int tiempoDecision = 9000;
  Timer? _decisionTimer;

  GameLogicDosJugadores();

  get score => null;

  Future<void> cargarAudios() async {
    try {
      await monedaPlayer.setAsset('assets/sonidos/moneda.mp3');
      await errorPlayer.setAsset('assets/sonidos/error.mp3');
    } catch (e) {
      print('Error cargando audios: $e');
    }
  }

  void generarNuevoObjeto() {
    objetoActual = objetos[random.nextInt(objetos.length)];
  }

  void cambiarTurno() {
    jugadorActual = (jugadorActual == 1) ? 2 : 1;
  }

  void cancelarTemporizador() {
    _decisionTimer?.cancel();
  }

  void iniciarTemporizadorDecision(Function onTiempoAgotado) {
    cancelarTemporizador();
    _decisionTimer = Timer(Duration(milliseconds: tiempoDecision), () {
      onTiempoAgotado();
    });
  }

  bool esDecisionCorrecta(bool decision, String tipoObjeto) {
    if (tipoObjeto == 'valioso') {
      return decision == true;
    } else if (tipoObjeto == 'maldito') {
      return decision == false;
    }
    return false;
  }

  Future<bool> evaluarDecision(bool decision) async {
    if (objetoActual == null) return false;

    String tipo = objetoActual!['tipo'];
    bool acierto = esDecisionCorrecta(decision, tipo);

    print('Jugador $jugadorActual → Mano cerca: $decision, Objeto: $tipo, Acierto: $acierto');

    if (acierto) {
      await monedaPlayer.seek(Duration.zero);
      await monedaPlayer.play();
      puntajes[jugadorActual] = puntajes[jugadorActual]! + (dobleOro[jugadorActual]! ? 20 : 10);
      combos[jugadorActual] = combos[jugadorActual]! + 1;
      if (combos[jugadorActual]! % 5 == 0 && tiempoDecision > 1000) {
        tiempoDecision -= 100;
      }
    } else {
      if (escudoActivo[jugadorActual]!) {
        escudoActivo[jugadorActual] = false;
        return true; // sin penalización
      }
      await errorPlayer.seek(Duration.zero);
      await errorPlayer.play();
      combos[jugadorActual] = 0;
    }

    return acierto;
  }

  void dispose() {
    monedaPlayer.dispose();
    errorPlayer.dispose();
    cancelarTemporizador();
  }
}
