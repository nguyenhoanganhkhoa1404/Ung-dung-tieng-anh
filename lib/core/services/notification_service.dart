import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_constants.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notificationsPlugin.initialize(initializationSettings);
    
    // Create notification channels
    await _createNotificationChannels();
  }
  
  Future<void> _createNotificationChannels() async {
    const reminderChannel = AndroidNotificationChannel(
      AppConstants.reminderChannelId,
      'Nhắc nhở học tập',
      description: 'Nhắc nhở học tập hàng ngày',
      importance: Importance.high,
    );
    
    const achievementChannel = AndroidNotificationChannel(
      AppConstants.achievementChannelId,
      'Thành tựu',
      description: 'Thông báo về thành tựu đạt được',
      importance: Importance.high,
    );
    
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminderChannel);
    
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(achievementChannel);
  }
  
  Future<void> showReminder(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.reminderChannelId,
      'Nhắc nhở học tập',
      channelDescription: 'Nhắc nhở học tập hàng ngày',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
  
  Future<void> showAchievement(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.achievementChannelId,
      'Thành tựu',
      channelDescription: 'Thông báo về thành tựu đạt được',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notificationsPlugin.show(
      1,
      title,
      body,
      notificationDetails,
    );
  }
  
  Future<void> scheduleDailyReminder(int hour, int minute) async {
    // Implementation for scheduling daily reminders
    // This would use flutter_local_notifications scheduling features
  }
  
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}

