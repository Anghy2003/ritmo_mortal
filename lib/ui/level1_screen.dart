// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ritmo_mortal_application/ui/juego1/game_logic.dart';
import 'package:ritmo_mortal_application/ui/juego1/proximity_service.dart';



class JuegoNivel1 extends StatefulWidget {
  final int numeroJugadores;

  const JuegoNivel1({Key? key, this.numeroJugadores = 1}) : super(key: key);

  @override
  _JuegoNivel1State createState() => _JuegoNivel1State();
}

class _JuegoNivel1State extends State<JuegoNivel1> with TickerProviderStateMixin {
  final GameLogicDosJugadores gameLogic = GameLogicDosJugadores();
  final ProximityService proximityService = ProximityService();

  bool isNear = false;
  bool usandoCamara = false;
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

  // Cámara y pose detection
  late CameraController _cameraController;
  late PoseDetector _poseDetector;
  List<CameraDescription> _cameras = [];
  bool manoDetectada = false;

  @override
  void initState() {
    super.initState();
    _escalaController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    escalaAnimada = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _escalaController, curve: Curves.easeInOut),
    );
    _verificarSensorYEmpezar();
  }

  Future<void> _verificarSensorYEmpezar() async {
    final disponible = await proximityService.isSensorAvailable();
    await gameLogic.cargarAudios();

    if (!disponible) {
      usandoCamara = true;
      await _iniciarDeteccionCamara();
    }

    _startCuentaRegresiva();
  }

  Future<void> _iniciarDeteccionCamara() async {
    await Permission.camera.request();
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras.first),
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController.initialize();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
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
    if (usandoCamara) {
      _startDeteccionMano();
    } else {
      _startListeningSensor();
    }
    _nuevoObjeto();
    _startTemporizadorJuego();
  }

  void _startListeningSensor() {
    proximityService.startListening((bool near) {
      if (!mounted || juegoTerminado) return;
      if (!evaluando) {
        setState(() => isNear = near);
        _evaluarDecision(near);
      }
    });
  }

 void _startDeteccionMano() {
  _cameraController.startImageStream((CameraImage image) async {
    if (!mounted || juegoTerminado || evaluando) return;

    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

   final inputImage = InputImage.fromBytes(
  bytes: bytes,
  metadata: InputImageMetadata(
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rotation: InputImageRotation.rotation0deg, // Enum correcto
    format: InputImageFormat.nv21,             // Enum correcto
    bytesPerRow: image.planes.first.bytesPerRow,
  ),
);

    final poses = await _poseDetector.processImage(inputImage);

    if (poses.isNotEmpty) {
      manoDetectada = true;
    } else {
      manoDetectada = false;
    }

    for (final pose in poses) {
      final wrist = pose.landmarks[PoseLandmarkType.rightWrist];
      final head = pose.landmarks[PoseLandmarkType.nose];

      if (wrist != null && head != null && !evaluando) {
        if ((wrist.y - head.y).abs() < 80) {
          _evaluarDecision(true);
        } else {
          _evaluarDecision(false);
        }
      }
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
    gameLogic.iniciarTemporizadorDecision(() => _evaluarDecision(null));
  }

  void _evaluarDecision(bool? decision) async {
    if (evaluando || juegoTerminado) return;
    evaluando = true;
    gameLogic.cancelarTemporizador();

    final acierto = decision == true ? await gameLogic.evaluarDecision(true) : false;

    if (!mounted) return;
    setState(() {
      mensaje = acierto ? "¡Bien!" : "¡Error!";
      falloVisual = !acierto;
      capitanVisible = !acierto;
    });

    _mensajeTimer?.cancel();
    _mensajeTimer = Timer(Duration(milliseconds: 600), () {
      if (mounted) setState(() => mensaje = '');
    });

    await Future.delayed(Duration(milliseconds: 600));
    if (widget.numeroJugadores == 2) gameLogic.cambiarTurno();
    evaluando = false;
    _nuevoObjeto();
  }

  void _finalizarJuego() {
    if (!mounted) return;
    juegoTerminado = true;
    _timerJuego?.cancel();
    proximityService.stopListening();

    if (usandoCamara) {
      _cameraController.stopImageStream();
    }

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
    if (usandoCamara) {
      _cameraController.dispose();
      _poseDetector.close();
    }
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
          if (usandoCamara && _cameraController.value.isInitialized)
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: CameraPreview(_cameraController),
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
