import 'package:chambaya/features/messages/domain/message.dart';

sealed class ChatState {}
class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatSuccess extends ChatState {
  final List<Message> messages;
  ChatSuccess({required this.messages});
}
class ChatFailure extends ChatState {
  final String error;
  ChatFailure({required this.error});
}
