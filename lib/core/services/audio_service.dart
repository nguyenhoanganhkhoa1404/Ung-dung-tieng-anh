import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Future<void> playAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Không thể phát audio: $e');
    }
  }
  
  Future<void> playLocalAudio(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Không thể phát audio: $e');
    }
  }
  
  Future<void> pause() async {
    await _audioPlayer.pause();
  }
  
  Future<void> resume() async {
    await _audioPlayer.play();
  }
  
  Future<void> stop() async {
    await _audioPlayer.stop();
  }
  
  void dispose() {
    _audioPlayer.dispose();
  }
  
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
}

