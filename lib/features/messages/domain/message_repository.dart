import 'package:chambaya/features/messages/domain/conversation.dart';
import 'package:chambaya/features/messages/domain/message.dart';

abstract class MessageRepository {
  Future<List<Conversation>> getConversations({required String userId});
  Future<List<Message>> getMessages({required String conversationId});
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  });
}