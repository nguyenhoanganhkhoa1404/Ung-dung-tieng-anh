import '../entities/learning_session_entity.dart';
import '../../data/repositories/analytics_repository_impl.dart';

/// Service để track phiên học THỰC TẾ
/// Ghi lại mỗi lần user học
class SessionTrackingService {
  final AnalyticsRepositoryImpl _repository;
  String? _currentSessionId;
  DateTime? _sessionStartTime;
  
  SessionTrackingService(this._repository);
  
  /// Bắt đầu phiên học mới
  Future<void> startSession({
    required String userId,
    required SkillType skill,
    required String lessonId,
  }) async {
    // Kết thúc session cũ nếu có
    if (_currentSessionId != null) {
      await endSession();
    }
    
    _sessionStartTime = DateTime.now();
    _currentSessionId = await _repository.startLearningSession(
      userId: userId,
      skill: skill,
      lessonId: lessonId,
    );
    
    print('✅ Session started: $_currentSessionId');
  }
  
  /// Kết thúc phiên học
  Future<void> endSession() async {
    if (_currentSessionId == null) return;
    
    await _repository.completeLearningSession(_currentSessionId!);
    
    final duration = _sessionStartTime != null
        ? DateTime.now().difference(_sessionStartTime!).inMinutes
        : 0;
    
    print('✅ Session ended: $_currentSessionId (${duration}min)');
    
    _currentSessionId = null;
    _sessionStartTime = null;
  }
  
  /// Lưu kết quả bài tập
  Future<void> saveExerciseResult({
    required String userId,
    required SkillType skill,
    required int correctAnswers,
    required int totalQuestions,
    required bool completed,
    String? lessonId,
  }) async {
    await _repository.saveExerciseResult(
      userId: userId,
      skill: skill,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      completed: completed,
      lessonId: lessonId,
      sessionId: _currentSessionId,
    );
    
    final accuracy = totalQuestions > 0
        ? (correctAnswers / totalQuestions * 100).toStringAsFixed(1)
        : '0';
    
    print('✅ Exercise result saved: $correctAnswers/$totalQuestions ($accuracy%)');
  }
  
  /// Kiểm tra có session đang chạy không
  bool get hasActiveSession => _currentSessionId != null;
  
  /// Lấy session ID hiện tại
  String? get currentSessionId => _currentSessionId;
  
  /// Lấy thời gian đã học trong session hiện tại
  Duration get currentSessionDuration {
    if (_sessionStartTime == null) return Duration.zero;
    return DateTime.now().difference(_sessionStartTime!);
  }
}

