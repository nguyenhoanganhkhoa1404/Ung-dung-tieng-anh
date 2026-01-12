import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/local/listening_exercise_bank.dart';
import '../../../data/repositories/analytics_repository_impl.dart';
import '../../../domain/entities/learning_session_entity.dart';

/// Practice page for ONE listening exercise:
/// - plays audio using TTS (reads transcript)
/// - shows 5–8 questions (MCQ / T-F / Fill blank / Matching)
/// - result summary + save to Firestore (exercise_results + learning_sessions)
class ListeningSessionPage extends StatefulWidget {
  final String userId;
  final ListeningExercise exercise;
  final Color color;

  const ListeningSessionPage({
    super.key,
    required this.userId,
    required this.exercise,
    required this.color,
  });

  @override
  State<ListeningSessionPage> createState() => _ListeningSessionPageState();
}

class _ListeningSessionPageState extends State<ListeningSessionPage> {
  late final FlutterTts _tts;
  late final AnalyticsRepositoryImpl _repo;

  int _index = 0;
  bool _showResult = false;

  // TTS state
  bool _isSpeaking = false;
  bool _isLoading = false;
  double _speechRate = 0.5; // Normal speed
  
  // Voice selection: 'male', 'female', 'auto' (auto switches for dialogues)
  String _voiceType = 'auto';
  List<Map<String, String>> _availableVoices = [];
  Map<String, String>? _maleVoice;
  Map<String, String>? _femaleVoice;

  // answers
  final Map<int, dynamic> _answers = {}; // qIndex -> answer payload
  final Map<int, TextEditingController> _fillControllers = {};
  final Map<int, Map<int, int>> _matchSelections = {}; // qIndex -> leftIndex -> rightIndex

  String? _sessionId;
  bool _persisted = false;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _repo = AnalyticsRepositoryImpl();
    Future.microtask(_initTtsAndSession);
  }

  Future<void> _initTtsAndSession() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;

    // start session tracking
    try {
      _sessionId = await _repo.startLearningSession(
        userId: uid,
        skill: SkillType.listening,
        lessonId: 'listening:${widget.exercise.type}:${widget.exercise.id}',
      );
    } catch (_) {}

    // Initialize TTS with better error handling
    try {
      // Check if TTS engine is available
      var engines = await _tts.getEngines;
      debugPrint('TTS Engines: $engines');
      
      var languages = await _tts.getLanguages;
      debugPrint('TTS Languages: $languages');
      
      // Get available voices (prefer US English)
      var voices = await _tts.getVoices;
      if (voices != null) {
        _availableVoices = List<Map<String, String>>.from(
          voices.map((v) => Map<String, String>.from(v as Map)),
        );
        debugPrint('Available voices: ${_availableVoices.length}');

        Map<String, String>? maleUs;
        Map<String, String>? femaleUs;
        Map<String, String>? maleEn;
        Map<String, String>? femaleEn;

        bool _isUsLocale(String locale) {
          final l = locale.toLowerCase();
          return l.contains('en-us') || l.contains('en_us') || l.contains('en us') || l.endsWith('us');
        }

        for (var voice in _availableVoices) {
          final name = (voice['name'] ?? '').toLowerCase();
          final locale = (voice['locale'] ?? '').toLowerCase();

          if (!locale.contains('en')) continue;

          final isUs = _isUsLocale(locale);
          final looksFemale = name.contains('female') ||
              name.contains('woman') ||
              name.contains('samantha') ||
              name.contains('karen') ||
              name.contains('victoria') ||
              name.contains('susan') ||
              name.contains('zira') ||
              name.contains('hazel') ||
              name.contains('jenny') ||
              name.contains('aria');
          final looksMale = name.contains('male') ||
              name.contains('man') ||
              name.contains('david') ||
              name.contains('mark') ||
              name.contains('james') ||
              name.contains('daniel') ||
              name.contains('guy') ||
              name.contains('tom');

          if (isUs) {
            if (looksFemale && femaleUs == null) femaleUs = voice;
            if (looksMale && maleUs == null) maleUs = voice;
          } else {
            if (looksFemale && femaleEn == null) femaleEn = voice;
            if (looksMale && maleEn == null) maleEn = voice;
          }
        }

        _femaleVoice = femaleUs ?? femaleEn;
        _maleVoice = maleUs ?? maleEn;

        // If still missing, fall back to first US/EN voices
        if (_femaleVoice == null || _maleVoice == null) {
          final usVoices = _availableVoices.where((v) {
            final locale = (v['locale'] ?? '').toLowerCase();
            return _isUsLocale(locale);
          }).toList();

          if (usVoices.length >= 2) {
            _maleVoice ??= usVoices[0];
            _femaleVoice ??= usVoices[1];
          } else if (usVoices.isNotEmpty) {
            _maleVoice ??= usVoices[0];
            _femaleVoice ??= usVoices[0];
          }

          if (_femaleVoice == null || _maleVoice == null) {
            final enVoices = _availableVoices.where((v) {
              final locale = (v['locale'] ?? '').toLowerCase();
              return locale.contains('en');
            }).toList();

            if (enVoices.isNotEmpty) {
              _maleVoice ??= enVoices.first;
              _femaleVoice ??= enVoices.length > 1 ? enVoices[1] : enVoices.first;
            }
          }
        }

        debugPrint('Male voice (preferred US): $_maleVoice');
        debugPrint('Female voice (preferred US): $_femaleVoice');
      }
      
      // Try to set language
      var result = await _tts.setLanguage('en-US');
      debugPrint('Set language result: $result');
      
      if (result == 0) {
        // en-US not available, try en-GB
        result = await _tts.setLanguage('en-GB');
        debugPrint('Set en-GB result: $result');
      }
      
      await _tts.setSpeechRate(_speechRate);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      
      // For Android
      await _tts.awaitSpeakCompletion(true);
      
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('TTS Init Error: $e');
    }

    _tts.setStartHandler(() {
      debugPrint('TTS Started');
      if (mounted) setState(() {
        _isSpeaking = true;
        _isLoading = false;
      });
    });

    _tts.setCompletionHandler(() {
      debugPrint('TTS Completed');
      if (mounted) setState(() {
        _isSpeaking = false;
        _isLoading = false;
      });
    });

    _tts.setCancelHandler(() {
      debugPrint('TTS Cancelled');
      if (mounted) setState(() {
        _isSpeaking = false;
        _isLoading = false;
      });
    });

    _tts.setErrorHandler((msg) {
      debugPrint('TTS Error: $msg');
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('TTS Error: $msg')),
        );
      }
    });
  }

  @override
  void dispose() {
    for (final c in _fillControllers.values) {
      c.dispose();
    }
    _tts.stop();
    super.dispose();
  }

  Future<void> _playAudio() async {
    // If already speaking, stop first
    if (_isSpeaking) {
      await _tts.stop();
      return;
    }
    
    // If loading, ignore
    if (_isLoading) return;
    
    // Start loading and speak
    setState(() => _isLoading = true);
    
    final text = widget.exercise.transcript.trim();
    debugPrint('Speaking text (${text.length} chars): ${text.substring(0, text.length > 100 ? 100 : text.length)}...');
    
    try {
      // Force US accent when possible
      await _tts.setLanguage('en-US');

      // Set voice based on selection
      if (_voiceType == 'male' && _maleVoice != null) {
        await _tts.setVoice(_maleVoice!);
        await _tts.setPitch(0.9); // Slightly lower pitch for male
      } else if (_voiceType == 'female' && _femaleVoice != null) {
        await _tts.setVoice(_femaleVoice!);
        await _tts.setPitch(1.1); // Slightly higher pitch for female
      } else if (_voiceType == 'auto') {
        // Auto mode: speak with dialogue detection
        await _speakWithDialogue(text);
        return;
      }
      
      var result = await _tts.speak(text);
      debugPrint('TTS speak result: $result');
      
      if (result != 1) {
        // Speaking failed
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot play audio. Please check TTS settings on your device.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('TTS speak error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
  
  /// Speak with automatic voice switching for dialogues
  Future<void> _speakWithDialogue(String text) async {
    // Force US accent
    await _tts.setLanguage('en-US');

    // Parse dialogue - look for patterns like "Name:" or "Speaker:"
    final lines = text.split('\n');
    final dialoguePattern = RegExp(r'^([A-Za-z\s]+):\s*(.+)$');
    
    // Track speakers and assign voices
    final speakerVoices = <String, bool>{}; // speaker -> isFemale
    var nextIsFemale = false;
    
    // Common female names
    final femaleNames = {'mom', 'mother', 'woman', 'girl', 'wife', 'daughter', 'sister', 
                         'amy', 'emma', 'sarah', 'lisa', 'kate', 'anna', 'jenny', 'mary',
                         'nina', 'alice', 'sophie', 'linda', 'maria', 'karen', 'susan',
                         'receptionist', 'waitress', 'hostess', 'nurse', 'she', 'her',
                         'customer', 'client', 'student', 'teacher', 'pharmacist', 'librarian'};
    
    final maleNames = {'dad', 'father', 'man', 'boy', 'husband', 'son', 'brother',
                       'tom', 'david', 'mark', 'john', 'james', 'ben', 'mike', 'chris',
                       'ryan', 'kevin', 'paul', 'dan', 'staff', 'waiter', 'doctor', 'he', 'him',
                       'manager', 'agent', 'operator', 'clerk'};
    
    // Build speech segments
    final segments = <Map<String, dynamic>>[];
    
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;
      
      final match = dialoguePattern.firstMatch(line);
      if (match != null) {
        final speaker = match.group(1)!.trim().toLowerCase();
        final dialogue = match.group(2)!.trim();
        
        // Assign voice to speaker if not already assigned
        if (!speakerVoices.containsKey(speaker)) {
          // Check if name suggests gender
          if (femaleNames.any((n) => speaker.contains(n))) {
            speakerVoices[speaker] = true; // female
          } else if (maleNames.any((n) => speaker.contains(n))) {
            speakerVoices[speaker] = false; // male
          } else {
            // Alternate between male/female for unknown speakers
            speakerVoices[speaker] = nextIsFemale;
            nextIsFemale = !nextIsFemale;
          }
        }
        
        segments.add({
          'text': dialogue,
          'isFemale': speakerVoices[speaker],
        });
      } else {
        // Not a dialogue line, use narrator voice (alternate)
        segments.add({
          'text': line,
          'isFemale': nextIsFemale,
        });
        nextIsFemale = !nextIsFemale;
      }
    }
    
    // If no dialogue found, just speak normally with alternating voices
    if (segments.isEmpty) {
      segments.add({'text': text, 'isFemale': false});
    }
    
    // Speak each segment
    for (var i = 0; i < segments.length; i++) {
      if (!mounted) return;
      
      final segment = segments[i];
      final isFemale = segment['isFemale'] as bool;
      final segmentText = segment['text'] as String;
      
      // Set appropriate voice
      if (isFemale && _femaleVoice != null) {
        await _tts.setVoice(_femaleVoice!);
        await _tts.setPitch(1.15);
      } else if (_maleVoice != null) {
        await _tts.setVoice(_maleVoice!);
        await _tts.setPitch(0.85);
      }
      
      debugPrint('Speaking segment ${i + 1}/${segments.length} (${isFemale ? "female" : "male"}): $segmentText');
      
      await _tts.speak(segmentText);
      await _tts.awaitSpeakCompletion(true);
      
      // Small pause between speakers
      if (i < segments.length - 1) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
    
    if (mounted) {
      setState(() {
        _isSpeaking = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _stopAudio() async {
    await _tts.stop();
    if (mounted) setState(() {
      _isSpeaking = false;
      _isLoading = false;
    });
  }

  Future<void> _changeSpeechRate(double rate) async {
    _speechRate = rate;
    await _tts.setSpeechRate(rate);
    if (mounted) setState(() {});
  }

  ListeningQuestion get _q => widget.exercise.questions[_index];

  bool get _isAnswered {
    final q = _q;
    final a = _answers[_index];
    switch (q.type) {
      case ListeningQuestionType.multipleChoice:
        return a is int;
      case ListeningQuestionType.trueFalse:
        return a is bool;
      case ListeningQuestionType.fillBlank:
        final c = _fillControllers[_index];
        return c != null && c.text.trim().isNotEmpty;
      case ListeningQuestionType.matching:
        final sel = _matchSelections[_index];
        return sel != null && sel.length == (q.matchLeft?.length ?? 0);
    }
  }

  void _next() {
    if (!_isAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng trả lời câu hỏi trước.')),
      );
      return;
    }

    if (_index < widget.exercise.questions.length - 1) {
      setState(() => _index++);
    } else {
      setState(() => _showResult = true);
      _persistResultIfNeeded();
    }
  }

  int _countCorrect() {
    int correct = 0;
    for (var i = 0; i < widget.exercise.questions.length; i++) {
      final q = widget.exercise.questions[i];
      switch (q.type) {
        case ListeningQuestionType.multipleChoice:
          final a = _answers[i];
          if (a is int && a == q.correctIndex) correct++;
          break;
        case ListeningQuestionType.trueFalse:
          final a = _answers[i];
          if (a is bool && a == q.correctBool) correct++;
          break;
        case ListeningQuestionType.fillBlank:
          final input = _fillControllers[i]?.text.trim().toLowerCase();
          final target = q.correctText?.trim().toLowerCase();
          if (input != null && target != null && input == target) correct++;
          break;
        case ListeningQuestionType.matching:
          final sel = _matchSelections[i];
          final pairs = q.matchPairs;
          if (sel != null && pairs != null) {
            final ok = pairs.entries.every((e) => sel[e.key] == e.value);
            if (ok) correct++;
          }
          break;
      }
    }
    return correct;
  }

  Future<void> _persistResultIfNeeded() async {
    if (_persisted) return;
    _persisted = true;

    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    final total = widget.exercise.questions.length;
    final correct = _countCorrect();

    try {
      await _repo.saveExerciseResult(
        userId: uid,
        skill: SkillType.listening,
        correctAnswers: correct,
        totalQuestions: total,
        completed: true,
        lessonId: 'listening:${widget.exercise.type}:${widget.exercise.id}',
        sessionId: _sessionId,
      );
      if (_sessionId != null) {
        await _repo.completeLearningSession(_sessionId!);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final bottomBarColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.exercise.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _showResult
                    ? 'Done'
                    : '${_index + 1}/${widget.exercise.questions.length}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: _showResult ? _buildResult() : _buildQuiz(),
        ),
      ),
      bottomNavigationBar: _showResult
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                color: bottomBarColor,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _index < widget.exercise.questions.length - 1
                          ? 'Next'
                          : 'View Results',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildQuiz() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildAudioCard(),
        const SizedBox(height: 14),
        _buildQuestionCard(_q),
        const SizedBox(height: 12),
        _buildAnswerArea(_q),
        const SizedBox(height: 90),
      ],
    );
  }

  Widget _buildAudioCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark ? Colors.grey[400] : const Color(0xFF6B7280);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.headphones_rounded, color: widget.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Listening Audio',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    Text(
                      '${widget.exercise.level} • TTS Audio',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Play/Stop button - single button
              IconButton(
                onPressed: _isLoading ? null : (_isSpeaking ? _stopAudio : _playAudio),
                icon: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                        ),
                      )
                    : Icon(
                        _isSpeaking ? Icons.stop_rounded : Icons.play_arrow_rounded,
                        color: _isSpeaking ? Colors.red : widget.color,
                        size: 28,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Speaking indicator
          if (_isSpeaking || _isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isSpeaking 
                    ? Colors.green.withOpacity(isDark ? 0.2 : 0.1)
                    : widget.color.withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (_isSpeaking) ...[
                    Icon(Icons.volume_up_rounded, color: Colors.green, size: 18),
                  ] else ...[
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                      ),
                    ),
                  ],
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isSpeaking ? '🔊 Đang phát...' : '⏳ Đang tải...',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _isSpeaking ? Colors.green : widget.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Speed control
          _buildSpeedControl(isDark, titleColor),
          
          const SizedBox(height: 12),
          
          // Voice control
          _buildVoiceControl(isDark),
        ],
      ),
    );
  }
  
  Widget _buildVoiceControl(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voice: ${_voiceType == 'auto' ? '🎭 Auto' : _voiceType == 'male' ? '👨 Male' : '👩 Female'}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildVoiceButton('🎭 Auto', 'auto', isDark),
            const SizedBox(width: 8),
            _buildVoiceButton('👨 Male', 'male', isDark),
            const SizedBox(width: 8),
            _buildVoiceButton('👩 Female', 'female', isDark),
          ],
        ),
        if (_voiceType == 'auto')
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Auto: Đổi giọng nam/nữ theo nhân vật',
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildVoiceButton(String label, String type, bool isDark) {
    final isSelected = _voiceType == type;
    return GestureDetector(
      onTap: () {
        if (!_isSpeaking) {
          setState(() => _voiceType = type);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.color
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[300] : Colors.grey[700]),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedControl(bool isDark, Color titleColor) {
    String speedLabel;
    if (_speechRate <= 0.3) {
      speedLabel = 'Slow';
    } else if (_speechRate <= 0.5) {
      speedLabel = 'Normal';
    } else {
      speedLabel = 'Fast';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Speed: $speedLabel',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildSpeedButton('🐢 Slow', 0.3, isDark),
            const SizedBox(width: 8),
            _buildSpeedButton('Normal', 0.5, isDark),
            const SizedBox(width: 8),
            _buildSpeedButton('🐇 Fast', 0.7, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedButton(String label, double rate, bool isDark) {
    final isSelected = (_speechRate - rate).abs() < 0.01;
    return GestureDetector(
      onTap: () => _changeSpeechRate(rate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.color
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[300] : Colors.grey[700]),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(ListeningQuestion q) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subTextColor = isDark ? Colors.grey[400] : const Color(0xFF6B7280);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_index + 1}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            q.prompt,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _typeLabel(q.type),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: subTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(ListeningQuestionType t) {
    switch (t) {
      case ListeningQuestionType.multipleChoice:
        return 'Multiple Choice';
      case ListeningQuestionType.trueFalse:
        return 'True / False';
      case ListeningQuestionType.fillBlank:
        return 'Fill in the blank';
      case ListeningQuestionType.matching:
        return 'Matching';
    }
  }

  Widget _buildAnswerArea(ListeningQuestion q) {
    switch (q.type) {
      case ListeningQuestionType.multipleChoice:
        return _buildMcq(q);
      case ListeningQuestionType.trueFalse:
        return _buildTrueFalse(q);
      case ListeningQuestionType.fillBlank:
        return _buildFillBlank(q);
      case ListeningQuestionType.matching:
        return _buildMatching(q);
    }
  }

  Widget _buildMcq(ListeningQuestion q) {
    final options = q.options ?? const <String>[];
    final selected = _answers[_index] as int?;

    return Column(
      children: List.generate(options.length, (i) {
        final isSelected = selected == i;
        return GestureDetector(
          onTap: () => setState(() => _answers[_index] = i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected ? widget.color.withOpacity(0.10) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? widget.color : Colors.grey.withOpacity(0.18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.color
                        : Colors.grey.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + i),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    options[i],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTrueFalse(ListeningQuestion q) {
    final selected = _answers[_index] as bool?;

    Widget btn(String label, bool value) {
      final isSelected = selected == value;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _answers[_index] = value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? widget.color : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.18),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        btn('True', true),
        const SizedBox(width: 10),
        btn('False', false),
      ],
    );
  }

  Widget _buildFillBlank(ListeningQuestion q) {
    final c = _fillControllers.putIfAbsent(
      _index,
      () => TextEditingController(text: _answers[_index] as String? ?? ''),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.18)),
      ),
      child: TextField(
        controller: c,
        onChanged: (v) => _answers[_index] = v,
        decoration: InputDecoration(
          hintText: 'Type your answer…',
          border: InputBorder.none,
          hintStyle: GoogleFonts.poppins(color: const Color(0xFF9CA3AF)),
        ),
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _buildMatching(ListeningQuestion q) {
    final left = q.matchLeft ?? const <String>[];
    final right = q.matchRight ?? const <String>[];

    final sel = _matchSelections.putIfAbsent(_index, () => {});
    // Keep right-side order stable because answer keys are stored by index.
    final stableRight = right;

    return Column(
      children: List.generate(left.length, (li) {
        final currentRight = sel[li];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.18)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  left[li],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: currentRight,
                hint: Text(
                  'Match',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                items: List.generate(stableRight.length, (ri) {
                  return DropdownMenuItem(
                    value: ri,
                    child: Text(
                      stableRight[ri],
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  );
                }),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    sel[li] = v;
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildResult() {
    final total = widget.exercise.questions.length;
    final correct = _countCorrect();
    final percent = total == 0 ? 0 : ((correct / total) * 100).round();
    final passed = percent >= 60;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
          ),
          child: Column(
            children: [
              Icon(
                passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 72,
                color: passed ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 12),
              Text(
                passed ? 'Great job!' : 'Keep practicing!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$correct / $total correct • $percent%',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Back',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Review (Answers)',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(widget.exercise.questions.length, (i) {
          final q = widget.exercise.questions[i];
          final isCorrect = _isCorrect(i, q);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Q${i + 1}: ${q.prompt}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                if ((q.explanation ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    q.explanation!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
      ],
    );
  }

  bool _isCorrect(int i, ListeningQuestion q) {
    switch (q.type) {
      case ListeningQuestionType.multipleChoice:
        final a = _answers[i];
        return a is int && a == q.correctIndex;
      case ListeningQuestionType.trueFalse:
        final a = _answers[i];
        return a is bool && a == q.correctBool;
      case ListeningQuestionType.fillBlank:
        final input = _fillControllers[i]?.text.trim().toLowerCase();
        final target = q.correctText?.trim().toLowerCase();
        return input != null && target != null && input == target;
      case ListeningQuestionType.matching:
        final sel = _matchSelections[i];
        final pairs = q.matchPairs;
        if (sel == null || pairs == null) return false;
        return pairs.entries.every((e) => sel[e.key] == e.value);
    }
  }
}


