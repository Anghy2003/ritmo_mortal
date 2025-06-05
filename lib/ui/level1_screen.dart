import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:just_audio/just_audio.dart';

class JuegoNivel1 extends StatefulWidget {
  @override
  _JuegoNivel1State createState() => _JuegoNivel1State();
}

class _JuegoNivel1State extends State<JuegoNivel1> with TickerProviderStateMixin {
  bool isNear = false;
  StreamSubscription<int>? _subscription;
  final AudioPlayer monedaPlayer = AudioPlayer();
  final AudioPlayer errorPlayer = AudioPlayer();

  final List<Map<String, dynamic>> objetos = [
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/cofre.png'},
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/pirata.png'},
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/copapirata.png'},
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/gorropirata.png'},
    {'tipo': 'valioso', 'imagen': 'lib/assets/imagenes/mapa.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/amarla.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/calaveraroja.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/coparoja.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/carro.png'},
    {'tipo': 'maldito', 'imagen': 'lib/assets/imagenes/pelota.png'},
  ];

  Timer? _timer;
  Map<String, dynamic>? objetoActual;
  Offset objetoOffset = Offset.zero;
  int score = 0;
  int combo = 0;
  bool falloVisual = false;
  bool capitanVisible = false;
  int tiempoDecision = 1500;

  late AnimationController _escalaController;
  late Animation<double> escalaAnimada;

  bool escudoActivo = false;
  bool dobleOro = false;

  int tiempoRestante = 60;
  Timer? _timerJuego;
  bool juegoTerminado = false;
  bool evaluando = false;

  String mensaje = '';
  Timer? _mensajeTimer;

  int cuentaRegresiva = 3;
  bool mostrandoCuenta = true;

  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de animacion para escala
    _escalaController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    // Define la animacion para escalar entre 08 y 12
    escalaAnimada = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _escalaController, curve: Curves.easeInOut),
    );

    // Inicia la cuenta regresiva antes de comenzar el juego
    _startCuentaRegresiva();

    // Carga los sonidos para el juego
    _loadAudioAssets();
  }

  // Carga los archivos de audio para moneda y error
  Future<void> _loadAudioAssets() async {
    try {
      await monedaPlayer.setAsset('assets/sonidos/moneda.mp3');
    } catch (e) {
      print("Error al cargar sonido de moneda: $e");
    }

    try {
      await errorPlayer.setAsset('assets/sonidos/error.mp3');
    } catch (e) {
      print("Error al cargar sonido de error: $e");
    }
  }

  // Controla la cuenta regresiva de 3 segundos mostrando los numeros
  void _startCuentaRegresiva() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (cuentaRegresiva > 1) {
        setState(() => cuentaRegresiva--);
      } else {
        timer.cancel();
        setState(() => mostrandoCuenta = false);
        // Cuando termina la cuenta inicia el juego
        _startJuego();
      }
    });
  }

  // Inicia la escucha del sensor y el temporizador del juego y genera el primer objeto
  void _startJuego() {
    _startListening();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nuevoObjeto();
    });
    _startTemporizadorJuego();
  }

  // Escucha eventos del sensor de proximidad y actualiza la variable isNear
  void _startListening() {
    _subscription = ProximitySensor.events.listen((int event) {
      if (!mounted) return;
      setState(() {
        isNear = event > 0;
      });
      // Evalua la decision del jugador con base en el estado del sensor
      _evaluarDecision(event > 0);
    });
  }

  // Inicia el temporizador del juego que cuenta hacia atras el tiempo restante
  void _startTemporizadorJuego() {
    _timerJuego = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (tiempoRestante > 0) {
        setState(() => tiempoRestante--);
      } else {
        // Cuando el tiempo se acaba finaliza el juego
        _finalizarJuego();
      }
    });
  }

  // Genera un nuevo objeto aleatorio en posicion aleatoria y resetea estados
  void _nuevoObjeto() {
    if (!mounted || juegoTerminado || evaluando) return;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Calcula posicion aleatoria dentro de la pantalla menos margenes
    final offsetX = random.nextDouble() * (width - 150);
    final offsetY = 200 + random.nextDouble() * (height - 400);

    _timer?.cancel();  
    setState(() {
      objetoActual = objetos[random.nextInt(objetos.length)];
      objetoOffset = Offset(offsetX, offsetY);
      falloVisual = false;
      capitanVisible = false;
    });

    // Inicia animacion de escala para el objeto
    _escalaController.forward(from: 0);
    // Define tiempo limite para que el jugador tome una decision
    _timer = Timer(Duration(milliseconds: tiempoDecision), () {
      // Si no hubo decision se evalua como fallo (decision null)
      _evaluarDecision(null);
    });
  }

  // Evalua la decision del jugador si estuvo cerca o no del sensor con el objeto actual
  void _evaluarDecision(bool? decision) async {
    if (!mounted || juegoTerminado || evaluando || objetoActual == null) return;
    evaluando = true;
    _timer?.cancel();

    try {
      bool esValioso = objetoActual!['tipo'] == 'valioso';
      // Acertado si la decision es true y el objeto valioso o decision false y objeto maldito
      bool acierto = (decision == true && esValioso) || (decision == false && !esValioso);

      if (acierto) {
        try {
          await monedaPlayer.seek(Duration.zero);
          await monedaPlayer.play();
        } catch (e) {
          print("Error reproduciendo sonido de moneda: $e");
        }

        if (!mounted) return;
        setState(() {
          score += dobleOro ? 20 : 10;
          combo += 1;
          mensaje = "¡Bien!";
          // Reduce tiempo para decidir cada 5 aciertos para aumentar dificultad
          if (combo % 5 == 0) {
            tiempoDecision = max(1000, tiempoDecision - 100);
          }
        });
      } else {
        // Si el escudo esta activo evita penalizacion y lo desactiva
        if (escudoActivo) {
          escudoActivo = false;
          return;
        }

        try {
          await errorPlayer.seek(Duration.zero);
          await errorPlayer.play();
        } catch (e) {
          print("Error reproduciendo sonido de error: $e");
        }

        if (!mounted) return;
        setState(() {
          combo = 0;
          mensaje = "¡Error!";
          falloVisual = true;
          capitanVisible = true;
        });
      }

      // Limpia el mensaje despues de 600 milisegundos
      _mensajeTimer?.cancel();
      _mensajeTimer = Timer(Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() => mensaje = '');
      });

      await Future.delayed(Duration(milliseconds: 600));
    } finally {
      evaluando = false;
    }

    // Si el juego no termino genera un nuevo objeto
    if (!juegoTerminado && mounted) _nuevoObjeto();
  }

  // Finaliza el juego deteniendo timers y muestra dialogo con resultado
  void _finalizarJuego() {
    if (!mounted) return;
    juegoTerminado = true;
    _timerJuego?.cancel();
    _timer?.cancel();
    _subscription?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('¡Tiempo terminado!'),
        content: Text('Tu puntuacion final: $score\nCombo maximo: $combo'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Cancela todas las subscripciones y timers y libera recursos
    _subscription?.cancel();
    _timer?.cancel();
    _timerJuego?.cancel();
    _mensajeTimer?.cancel();
    _escalaController.dispose();
    monedaPlayer.dispose();
    errorPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo del juego que cambia a rojo si hubo fallo
          Positioned.fill(
            child: Image.asset(
              'lib/assets/imagenes/fondojuego.png',
              fit: BoxFit.cover,
              color: falloVisual ? Colors.red.withOpacity(0.4) : null,
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // Muestra el objeto actual con animacion si la cuenta ya termino
          if (objetoActual != null && !mostrandoCuenta)
            Positioned(
              left: objetoOffset.dx,
              top: objetoOffset.dy,
              child: ScaleTransition(
                scale: escalaAnimada,
                child: Image.asset(
                  objetoActual!['imagen'],
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          // Muestra la cuenta regresiva al centro
          if (mostrandoCuenta)
            Center(
              child: Text(
                cuentaRegresiva > 1 ? '$cuentaRegresiva' : '¡YA!',
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
            ),
          // Boton para salir cancela todo y sale
          Positioned(
            top: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
               // Cancela timers y subscripciones y sale del juego
                _timer?.cancel();
                _timerJuego?.cancel();
                _subscription?.cancel();
                Navigator.of(context).pop();
              },
              child: Text('Salir'),
            ),
          ),
          // Muestra puntaje combo mensaje y tiempo en pantalla
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Puntuacion: $score',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 5, color: Colors.black)]),
                ),
                SizedBox(height: 5),
                Text(
                  'Combo: $combo',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 5, color: Colors.black)]),
                ),
                SizedBox(height: 5),
                if (mensaje.isNotEmpty)
                  Text(
                    mensaje,
                    style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 5, color: Colors.black)]),
                  ),
                SizedBox(height: 5),
                Text(
                  'Tiempo: $tiempoRestante s',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 5, color: Colors.black)]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
