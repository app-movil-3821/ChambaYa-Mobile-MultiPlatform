import 'package:chambaya/features/messages/domain/conversation.dart';

sealed class MessagesState {}
class MessagesInitial  extends MessagesState {}
class MessagesLoading  extends MessagesState {}
class MessagesSuccess  extends MessagesState {
  final List<Conversation> conversations;
  MessagesSuccess({required this.conversations});
}
class MessagesFailure  extends MessagesState {
  final String error;
  MessagesFailure({required this.error});
}