import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech Service for pronunciation
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    _flutterTts = FlutterTts();
    
    // Set English language for pronunciation
    await _flutterTts!.setLanguage('en-US');
    await _flutterTts!.setSpeechRate(0.45); // Slower for learning
    await _flutterTts!.setVolume(1.0);
    await _flutterTts!.setPitch(1.0);
    
    _isInitialized = true;
  }

  /// Speak a word or sentence in English
  Future<void> speak(String text) async {
    if (!_isInitialized) await init();
    await _flutterTts?.stop();
    await _flutterTts?.speak(text);
  }

  /// Stop speaking
  Future<void> stop() async {
    await _flutterTts?.stop();
  }

  /// Set speech rate (0.0 - 1.0, default 0.45)
  Future<void> setSpeechRate(double rate) async {
    await _flutterTts?.setSpeechRate(rate);
  }

  /// Set language (e.g., 'en-US', 'en-GB')
  Future<void> setLanguage(String language) async {
    await _flutterTts?.setLanguage(language);
  }

  /// Dispose TTS
  void dispose() {
    _flutterTts?.stop();
  }
}

