import 'package:chambaya/features/notifications/data/notification_service.dart';
import 'package:chambaya/features/notifications/domain/app_notification.dart';
import 'package:chambaya/features/notifications/domain/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService service;

  const NotificationRepositoryImpl({required this.service});

  @override
  Future<List<AppNotification>> getByUser({required String userId}) async {
    final dtos = await service.getByUser(userId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<AppNotification>> getUnreadByUser({required String userId}) async {
    final dtos = await service.getUnreadByUser(userId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> markAsRead({required String notificationId}) {
    return service.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead({required String userId}) {
    return service.markAllAsRead(userId);
  }
}
