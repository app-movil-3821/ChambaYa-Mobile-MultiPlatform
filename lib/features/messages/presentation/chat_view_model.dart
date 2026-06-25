import 'dart:async';

import 'package:chambaya/features/messages/domain/message_repository.dart';
import 'package:chambaya/features/messages/presentation/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatViewModel extends Cubit<ChatState> {
  final MessageRepository repository;
  final String conversationId;
  final String senderId;

  Timer? _pollingTimer;

  ChatViewModel({
    required this.repository,
    required this.conversationId,
    required this.senderId,
  }) : super(ChatInitial());

  Future<void> loadMessages() async {
    emit(ChatLoading());
    try {
      final messages = await repository.getMessages(conversationId: conversationId);
      emit(ChatSuccess(messages: messages));
      _startPolling();
    } catch (e) {
      emit(ChatFailure(error: 'Error al cargar mensajes'));
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _refreshSilently());
  }

  Future<void> _refreshSilently() async {
    try {
      final messages = await repository.getMessages(conversationId: conversationId);
      final current = state;
      if (current is ChatSuccess && messages.length != current.messages.length) {
        emit(ChatSuccess(messages: messages));
      }
    } catch (_) {
      // fallo silencioso — espera el próximo ciclo
    }
  }

  Future<void> sendMessage({required String content}) async {
    try {
      await repository.sendMessage(
        conversationId: conversationId,
        senderId:       senderId,
        content:        content,
      );
      // recarga inmediata tras enviar sin esperar el poll
      final messages = await repository.getMessages(conversationId: conversationId);
      emit(ChatSuccess(messages: messages));
    } catch (e) {
      emit(ChatFailure(error: 'Error al enviar mensaje'));
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
