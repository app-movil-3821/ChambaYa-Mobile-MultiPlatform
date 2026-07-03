import 'package:chambaya/core/di/dependency_injection.dart';
import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/notifications/domain/notification_repository.dart';
import 'package:chambaya/features/notifications/presentation/notifications_page.dart';
import 'package:chambaya/features/notifications/presentation/notifications_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBellButton extends StatefulWidget {
  final Color? color;

  const NotificationBellButton({super.key, this.color});

  @override
  State<NotificationBellButton> createState() => _NotificationBellButtonState();
}

class _NotificationBellButtonState extends State<NotificationBellButton> {
  bool _hasUnread = false;

  @override
  void initState() {
    super.initState();
    _checkUnread();
  }

  Future<void> _checkUnread() async {
    final userId = await getIt<TokenStorage>().getUserId();
    if (userId == null) return;
    try {
      final unread = await getIt<NotificationRepository>().getUnreadByUser(userId: userId);
      if (mounted) setState(() => _hasUnread = unread.isNotEmpty);
    } catch (_) {}
  }

  Future<void> _open() async {
    final userId = await getIt<TokenStorage>().getUserId();
    if (userId == null || !mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<NotificationsViewModel>()..loadNotifications(userId: userId),
          child: const NotificationsPage(),
        ),
      ),
    );
    _checkUnread();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: widget.color),
          onPressed: _open,
        ),
        if (_hasUnread)
          Positioned(
            right: 10, top: 10,
            child: Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }
}
