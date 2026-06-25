class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String sentAt;
  final bool read;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.read,
  });
}