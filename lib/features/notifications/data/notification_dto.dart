import 'package:chambaya/features/notifications/domain/app_notification.dart';

class NotificationDto {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool read;
  final String createdAt;

  const NotificationDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id:     json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title:  json['title']?.toString() ?? '',
      message: json['message']?.toString()
          ?? json['content']?.toString()
          ?? json['body']?.toString()
          ?? '',
      type: json['type']?.toString() ?? '',
      read: json['read'] as bool?
          ?? json['isRead'] as bool?
          ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  AppNotification toDomain() => AppNotification(
    id:        id,
    userId:    userId,
    title:     title,
    message:   message,
    type:      type,
    read:      read,
    createdAt: createdAt,
  );
}
