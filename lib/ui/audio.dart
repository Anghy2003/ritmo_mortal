import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> startMusic() async {
    try {
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.setAsset('assets/sonidos/fondomenu.mp3');
      await _audioPlayer.play();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error al reproducir audio: $e');
    }
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> pauseMusic() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> resumeMusic() async {
    await _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
