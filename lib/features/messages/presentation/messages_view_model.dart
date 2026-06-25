import 'package:chambaya/features/messages/domain/message_repository.dart';
import 'package:chambaya/features/messages/presentation/messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesViewModel extends Cubit<MessagesState> {
  final MessageRepository repository;
  String currentUserId = '';

  MessagesViewModel({required this.repository}) : super(MessagesInitial());

  Future<void> loadConversations({required String userId}) async {
    currentUserId = userId;
    emit(MessagesLoading());
    try {
      final conversations = await repository.getConversations(userId: userId);
      emit(MessagesSuccess(conversations: conversations));
    } catch (e) {
      emit(MessagesFailure(error: 'Error al cargar mensajes'));
    }
  }
}