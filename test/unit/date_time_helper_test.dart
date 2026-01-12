import 'package:flutter_test/flutter_test.dart';
import 'package:ung_dung_hoc_tieng_anh/core/utils/date_time_helper.dart';

void main() {
  group('DateTimeHelper Tests', () {
    test('formatDate should return correct format', () {
      final date = DateTime(2024, 1, 15);
      expect(DateTimeHelper.formatDate(date), '15/01/2024');
    });

    test('formatTime should return correct format', () {
      final date = DateTime(2024, 1, 15, 14, 30);
      expect(DateTimeHelper.formatTime(date), '14:30');
    });

    test('formatDateTime should return correct format', () {
      final date = DateTime(2024, 1, 15, 14, 30);
      expect(DateTimeHelper.formatDateTime(date), '15/01/2024 14:30');
    });

    test('isSameDay should correctly identify same day', () {
      final date1 = DateTime(2024, 1, 15, 10, 0);
      final date2 = DateTime(2024, 1, 15, 20, 0);
      final date3 = DateTime(2024, 1, 16, 10, 0);

      expect(DateTimeHelper.isSameDay(date1, date2), true);
      expect(DateTimeHelper.isSameDay(date1, date3), false);
    });

    test('getTimeAgo should return correct relative time', () {
      final now = DateTime.now();
      
      final minutesAgo = now.subtract(const Duration(minutes: 5));
      expect(DateTimeHelper.getTimeAgo(minutesAgo), '5 phút trước');

      final hoursAgo = now.subtract(const Duration(hours: 2));
      expect(DateTimeHelper.getTimeAgo(hoursAgo), '2 giờ trước');

      final daysAgo = now.subtract(const Duration(days: 3));
      expect(DateTimeHelper.getTimeAgo(daysAgo), '3 ngày trước');
    });

    test('calculateStreak should return correct value', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      // Same day - already studied today
      expect(DateTimeHelper.calculateStreak(today), 0);

      // Yesterday - continue streak
      expect(DateTimeHelper.calculateStreak(yesterday), 1);

      // Two days ago - lost streak
      expect(DateTimeHelper.calculateStreak(twoDaysAgo), -1);
    });
  });
}

