import 'package:chambaya/features/notifications/domain/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getByUser({required String userId});
  Future<List<AppNotification>> getUnreadByUser({required String userId});
  Future<void> markAsRead({required String notificationId});
  Future<void> markAllAsRead({required String userId});
}
