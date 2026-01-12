import '../domain/entities/user_progress_entity.dart';

class ErrorAnalysisEngine {
  /// Analyze common errors and provide insights
  Map<String, dynamic> analyzeErrors(List<UserProgressEntity> progressHistory) {
    final totalQuestions = progressHistory.fold<int>(
      0,
      (sum, p) => sum + p.totalQuestions,
    );
    
    final totalCorrect = progressHistory.fold<int>(
      0,
      (sum, p) => sum + p.correctAnswers,
    );
    
    final overallAccuracy = totalQuestions > 0
        ? totalCorrect / totalQuestions
        : 0.0;
    
    // Identify patterns
    final weakTopics = _identifyWeakTopics(progressHistory);
    final strongTopics = _identifyStrongTopics(progressHistory);
    final improvementRate = _calculateImprovementRate(progressHistory);
    
    return {
      'overallAccuracy': overallAccuracy,
      'totalQuestions': totalQuestions,
      'totalCorrect': totalCorrect,
      'weakTopics': weakTopics,
      'strongTopics': strongTopics,
      'improvementRate': improvementRate,
      'recommendations': _generateRecommendations(
        overallAccuracy,
        weakTopics,
        improvementRate,
      ),
    };
  }
  
  List<String> _identifyWeakTopics(List<UserProgressEntity> progress) {
    // In production, this would analyze actual topic data
    // For now, simulate based on accuracy
    final weakLessons = progress.where((p) => p.accuracy < 0.6).toList();
    
    if (weakLessons.length > progress.length * 0.3) {
      return ['grammar', 'vocabulary'];
    }
    
    return ['pronunciation'];
  }
  
  List<String> _identifyStrongTopics(List<UserProgressEntity> progress) {
    final strongLessons = progress.where((p) => p.accuracy >= 0.8).toList();
    
    if (strongLessons.length > progress.length * 0.5) {
      return ['reading', 'listening'];
    }
    
    return ['vocabulary'];
  }
  
  double _calculateImprovementRate(List<UserProgressEntity> progress) {
    if (progress.length < 2) return 0.0;
    
    // Sort by date
    final sorted = progress.toList()
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
    
    // Compare first half vs second half accuracy
    final midPoint = sorted.length ~/ 2;
    final firstHalf = sorted.sublist(0, midPoint);
    final secondHalf = sorted.sublist(midPoint);
    
    final firstHalfAccuracy = firstHalf.isEmpty
        ? 0.0
        : firstHalf.map((p) => p.accuracy).reduce((a, b) => a + b) /
            firstHalf.length;
    
    final secondHalfAccuracy = secondHalf.isEmpty
        ? 0.0
        : secondHalf.map((p) => p.accuracy).reduce((a, b) => a + b) /
            secondHalf.length;
    
    return secondHalfAccuracy - firstHalfAccuracy;
  }
  
  List<String> _generateRecommendations(
    double accuracy,
    List<String> weakTopics,
    double improvementRate,
  ) {
    final recommendations = <String>[];
    
    if (accuracy < 0.5) {
      recommendations.add('Hãy dành nhiều thời gian hơn cho việc ôn tập cơ bản');
    } else if (accuracy < 0.7) {
      recommendations.add('Tăng cường luyện tập các chủ đề: ${weakTopics.join(", ")}');
    } else {
      recommendations.add('Tiến độ tốt! Hãy thử các bài học nâng cao');
    }
    
    if (improvementRate > 0.1) {
      recommendations.add('Bạn đang tiến bộ rất tốt! Tiếp tục duy trì');
    } else if (improvementRate < 0) {
      recommendations.add('Hãy thử thay đổi phương pháp học để cải thiện');
    }
    
    if (weakTopics.isNotEmpty) {
      recommendations.add(
        'Tập trung vào: ${weakTopics.join(", ")} để cải thiện điểm yếu',
      );
    }
    
    return recommendations;
  }
  
  /// Provide personalized feedback for a lesson
  String provideFeedback(UserProgressEntity progress) {
    final accuracy = progress.accuracy;
    final timeSpent = progress.timeSpentSeconds;
    
    if (accuracy >= 0.9) {
      return '🎉 Xuất sắc! Bạn đã làm rất tốt bài này.';
    } else if (accuracy >= 0.7) {
      return '👍 Tốt lắm! Hãy tiếp tục cố gắng.';
    } else if (accuracy >= 0.5) {
      return '📚 Bạn cần ôn tập thêm chủ đề này.';
    } else {
      return '💪 Đừng nản lòng! Hãy thử học lại từ đầu.';
    }
  }
  
  /// Suggest next actions based on performance
  List<String> suggestNextActions(UserProgressEntity progress) {
    final suggestions = <String>[];
    
    if (progress.accuracy < 0.6) {
      suggestions.add('Xem lại lý thuyết');
      suggestions.add('Làm lại bài tập');
      suggestions.add('Xem video hướng dẫn');
    } else if (progress.accuracy < 0.8) {
      suggestions.add('Làm thêm bài tập nâng cao');
      suggestions.add('Ôn tập các câu sai');
    } else {
      suggestions.add('Chuyển sang bài học tiếp theo');
      suggestions.add('Thử thách nâng cao');
    }
    
    return suggestions;
  }
}

