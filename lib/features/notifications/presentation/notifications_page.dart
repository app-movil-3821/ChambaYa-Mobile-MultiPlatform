import 'package:chambaya/features/notifications/domain/app_notification.dart';
import 'package:chambaya/features/notifications/presentation/notifications_state.dart';
import 'package:chambaya/features/notifications/presentation/notifications_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _blue = Color(0xFF1A3FD8);

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<NotificationsViewModel, NotificationsState>(
            builder: (context, state) {
              final hasUnread = state is NotificationsLoaded && state.unreadCount > 0;
              if (!hasUnread) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context.read<NotificationsViewModel>().markAllAsRead(),
                child: const Text('Marcar todo leído', style: TextStyle(color: _blue)),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsViewModel, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading || state is NotificationsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationsError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.grey)));
          }

          final notifications = (state as NotificationsLoaded).notifications;
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tienes notificaciones', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return _NotificationTile(
                notification: n,
                onTap: () {
                  if (!n.read) context.read<NotificationsViewModel>().markAsRead(n.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final read = notification.read;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: read ? const Color(0xFFF0F0F5) : const Color(0xFFE8EDFB),
            shape: BoxShape.circle,
          ),
          child: Icon(
            read ? Icons.notifications_none : Icons.notifications_active,
            color: read ? Colors.grey : _blue,
          ),
        ),
        title: Text(
          notification.title.isNotEmpty ? notification.title : 'Notificación',
          style: TextStyle(fontWeight: read ? FontWeight.w500 : FontWeight.w800),
        ),
        subtitle: Text(notification.message),
        trailing: read
            ? null
            : Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
        onTap: onTap,
      ),
    );
  }
}
