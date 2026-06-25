import 'package:chambaya/features/messages/data/message_service.dart';
import 'package:chambaya/features/messages/domain/conversation.dart';
import 'package:chambaya/features/messages/domain/message.dart';
import 'package:chambaya/features/messages/domain/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageService service;

  const MessageRepositoryImpl({required this.service});

  @override
  Future<List<Conversation>> getConversations({required String userId}) async {
    final dtos = await service.getConversations(userId: userId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Message>> getMessages({required String conversationId}) async {
    final dtos = await service.getMessages(conversationId: conversationId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    final dto = await service.sendMessage(
      conversationId: conversationId,
      senderId:       senderId,
      content:        content,
    );
    return dto.toDomain();
  }
}