import 'package:chambaya/features/notifications/domain/notification_repository.dart';
import 'package:chambaya/features/notifications/presentation/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsViewModel extends Cubit<NotificationsState> {
  final NotificationRepository repository;
  String _userId = '';

  NotificationsViewModel({required this.repository}) : super(NotificationsInitial());

  Future<void> loadNotifications({required String userId}) async {
    _userId = userId;
    emit(NotificationsLoading());
    try {
      final notifications = await repository.getByUser(userId: userId);
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError('No se pudieron cargar las notificaciones'));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final s = state;
    if (s is! NotificationsLoaded) return;
    try {
      await repository.markAsRead(notificationId: notificationId);
      final updated = s.notifications
          .map((n) => n.id == notificationId ? n.copyWith(read: true) : n)
          .toList();
      emit(NotificationsLoaded(updated));
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    final s = state;
    if (s is! NotificationsLoaded || _userId.isEmpty) return;
    try {
      await repository.markAllAsRead(userId: _userId);
      final updated = s.notifications.map((n) => n.copyWith(read: true)).toList();
      emit(NotificationsLoaded(updated));
    } catch (_) {}
  }
}
