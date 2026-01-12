class AnalyticsService {
  Future<void> logEvent(String eventName, Map<String, dynamic> parameters) async {
    // Log analytics event
    // Could be implemented with Firebase Analytics or custom backend
    print('Analytics Event: $eventName - $parameters');
  }
  
  Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', {'screen_name': screenName});
  }
  
  Future<void> logLessonCompleted(String lessonId, int score) async {
    await logEvent('lesson_completed', {
      'lesson_id': lessonId,
      'score': score,
    });
  }
  
  Future<void> logVocabularyLearned(String wordId) async {
    await logEvent('vocabulary_learned', {'word_id': wordId});
  }
  
  Future<void> logStreakMilestone(int streakDays) async {
    await logEvent('streak_milestone', {'streak_days': streakDays});
  }
  
  Future<void> logLevelUp(int newLevel) async {
    await logEvent('level_up', {'new_level': newLevel});
  }
}

