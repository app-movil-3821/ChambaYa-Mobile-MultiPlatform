class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool read;
  final String createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  AppNotification copyWith({bool? read}) => AppNotification(
    id:        id,
    userId:    userId,
    title:     title,
    message:   message,
    type:      type,
    read:      read ?? this.read,
    createdAt: createdAt,
  );
}
