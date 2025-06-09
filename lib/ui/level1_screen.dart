import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ritmo_mortal_application/ui/juego1/game_logic.dart';
import 'package:ritmo_mortal_application/ui/juego1/proximity_service.dart';

class JuegoNivel1 extends StatefulWidget {
  final int numeroJugadores; // 1 o 2

  const JuegoNivel1({Key? key, this.numeroJugadores = 1}) : super(key: key);

  @override
  _JuegoNivel1State createState() => _JuegoNivel1State();
}

class _JuegoNivel1State extends State<JuegoNivel1> with TickerProviderStateMixin {
  final GameLogicDosJugadores gameLogic = GameLogicDosJugadores();
  final ProximityService proximityService = ProximityService();

  bool isNear = false;
  bool mostrandoCuenta = true;
  int cuentaRegresiva = 3;
  bool falloVisual = false;
  bool capitanVisible = false;
  bool juegoTerminado = false;
  bool evaluando = false;
  String mensaje = '';
  int tiempoRestante = 50;

  late AnimationController _escalaController;
  late Animation<double> escalaAnimada;

  Offset objetoOffset = Offset.zero;

  Timer? _timerCuenta;
  Timer? _timerJuego;
  Timer? _mensajeTimer;

  @override
  void initState() {
    super.initState();

    _escalaController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    escalaAnimada = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _escalaController, curve: Curves.easeInOut),
    );

    _verificarSensorYEmpezar();
  }

  void _verificarSensorYEmpezar() async {
    final disponible = await proximityService.isSensorAvailable();
    if (!disponible) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('Sensor no disponible', style: TextStyle(fontFamily: 'JollyLodger')),
          content: Text('Este dispositivo no tiene sensor de proximidad.', style: TextStyle(fontFamily: 'JollyLodger')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Salir', style: TextStyle(fontFamily: 'JollyLodger')),
            ),
          ],
        ),
      );
      return;
    }

    await gameLogic.cargarAudios();
    _startCuentaRegresiva();
  }

  void _startCuentaRegresiva() {
    _timerCuenta = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (cuentaRegresiva > 1) {
        setState(() => cuentaRegresiva--);
      } else {
        timer.cancel();
        setState(() => mostrandoCuenta = false);
        _startJuego();
      }
    });
  }

  void _startJuego() {
    _startListeningSensor();
    _nuevoObjeto();
    _startTemporizadorJuego();
  }

  void _startListeningSensor() {
    proximityService.startListening((bool near) {
      if (!mounted || juegoTerminado) return;

      if (!evaluando) {
        setState(() {
          isNear = near;
        });
        _evaluarDecision(near);
      }
    });
  }

  void _startTemporizadorJuego() {
    _timerJuego = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (tiempoRestante > 0) {
        setState(() => tiempoRestante--);
      } else {
        timer.cancel();
        _finalizarJuego();
      }
    });
  }

  void _nuevoObjeto() {
    if (!mounted || juegoTerminado || evaluando) return;

    final size = MediaQuery.of(context).size;
    final offsetX = gameLogic.random.nextDouble() * (size.width - 150);
    final offsetY = 200 + gameLogic.random.nextDouble() * (size.height - 400);

    setState(() {
      gameLogic.generarNuevoObjeto();
      objetoOffset = Offset(offsetX, offsetY);
      falloVisual = false;
      capitanVisible = false;
    });

    _escalaController.forward(from: 0);

    gameLogic.iniciarTemporizadorDecision(() {
      _evaluarDecision(null);
    });
  }

  void _evaluarDecision(bool? decision) async {
    if (evaluando || juegoTerminado) return;

    evaluando = true;
    gameLogic.cancelarTemporizador();

    bool? acierto;

    if (decision == null) {
      acierto = false;
    } else {
      acierto = await gameLogic.evaluarDecision(decision);
    }

    if (!mounted) return;

    setState(() {
      mensaje = acierto == true ? "¡Bien!" : "¡Error!";
      falloVisual = acierto == false;
      capitanVisible = acierto == false;
    });

    _mensajeTimer?.cancel();
    _mensajeTimer = Timer(Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => mensaje = '');
    });

    await Future.delayed(Duration(milliseconds: 600));

    if (widget.numeroJugadores == 2) {
      gameLogic.cambiarTurno();
    }

    evaluando = false;
    _nuevoObjeto();
  }

  void _finalizarJuego() {
    if (!mounted) return;
    juegoTerminado = true;
    _timerJuego?.cancel();
    proximityService.stopListening();

    final puntaje1 = gameLogic.puntajes[1] ?? 0;
    final puntaje2 = gameLogic.puntajes[2] ?? 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('¡Tiempo terminado!', style: TextStyle(fontFamily: 'JollyLodger')),
        content: Text(
          widget.numeroJugadores == 1
              ? 'Puntuación final: $puntaje1'
              : 'Jugador 1: $puntaje1\nJugador 2: $puntaje2\n¡${_determinarGanador(puntaje1, puntaje2)}!',
          style: TextStyle(fontFamily: 'JollyLodger'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Salir', style: TextStyle(fontFamily: 'JollyLodger')),
          ),
        ],
      ),
    );
  }

  String _determinarGanador(int p1, int p2) {
    if (p1 > p2) return 'Ganador: Jugador 1';
    if (p2 > p1) return 'Ganador: Jugador 2';
    return '¡Empate!';
  }

  @override
  void dispose() {
    proximityService.stopListening();
    _timerCuenta?.cancel();
    _timerJuego?.cancel();
    _mensajeTimer?.cancel();
    _escalaController.dispose();
    gameLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/imagenes/fondojuego.png',
              fit: BoxFit.cover,
              color: falloVisual ? Colors.red.withOpacity(0.4) : null,
              colorBlendMode: BlendMode.darken,
            ),
          ),
          if (gameLogic.objetoActual != null && !mostrandoCuenta)
            Positioned(
              left: objetoOffset.dx,
              top: objetoOffset.dy,
              child: ScaleTransition(
                scale: escalaAnimada,
                child: Image.asset(
                  gameLogic.objetoActual!['imagen'],
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          if (mostrandoCuenta)
            Center(
              child: Text(
                cuentaRegresiva > 1 ? '$cuentaRegresiva' : '¡YA!',
                style: TextStyle(fontSize: 72, fontFamily: 'JollyLodger', color: Colors.white),
              ),
            ),
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              widget.numeroJugadores == 2
                  ? 'Turno: Jugador ${gameLogic.jugadorActual}'
                  : 'Jugador único',
              style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'JollyLodger'),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Text(
              'Tiempo: $tiempoRestante',
              style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'JollyLodger'),
            ),
          ),
          if (mensaje.isNotEmpty)
            Center(
              child: Text(
                mensaje,
                style: TextStyle(fontSize: 48, color: Colors.yellow, fontFamily: 'JollyLodger'),
              ),
            ),
        ],
      ),
    );
  }
}
