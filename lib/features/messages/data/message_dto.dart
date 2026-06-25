import 'package:chambaya/features/messages/domain/conversation.dart';
import 'package:chambaya/features/messages/domain/message.dart';

class ConversationDto {
  final String id;
  final String jobId;
  final String enrollmentId;
  final String contractorId;
  final String workerId;
  final String status;
  final String createdAt;
  final String updatedAt;

  const ConversationDto({
    required this.id,
    required this.jobId,
    required this.enrollmentId,
    required this.contractorId,
    required this.workerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    return ConversationDto(
      id:           json['id']           as String,
      jobId:        json['jobId']        as String,
      enrollmentId: json['enrollmentId'] as String,
      contractorId: json['contractorId'] as String,
      workerId:     json['workerId']     as String,
      status:       json['status']       as String,
      createdAt:    json['createdAt']    as String,
      updatedAt:    json['updatedAt']    as String,
    );
  }

  Conversation toDomain() => Conversation(
    id:           id,
    jobId:        jobId,
    enrollmentId: enrollmentId,
    contractorId: contractorId,
    workerId:     workerId,
    status:       status,
    createdAt:    createdAt,
    updatedAt:    updatedAt,
  );
}

class MessageDto {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String sentAt;
  final bool read;

  const MessageDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.read,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      id:             json['id']             as String,
      conversationId: json['conversationId'] as String,
      senderId:       json['senderId']       as String,
      content:        json['content']        as String,
      sentAt:         json['sentAt']         as String,
      read:           json['read']           as bool? ?? false,
    );
  }

  Message toDomain() => Message(
    id:             id,
    conversationId: conversationId,
    senderId:       senderId,
    content:        content,
    sentAt:         sentAt,
    read:           read,
  );
}