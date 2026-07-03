import 'package:chambaya/features/notifications/domain/app_notification.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;
  NotificationsLoaded(this.notifications);

  int get unreadCount => notifications.where((n) => !n.read).length;
}
