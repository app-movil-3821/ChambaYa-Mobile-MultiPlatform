import 'package:chambaya/features/home/domain/job_repository.dart';
import 'package:chambaya/features/messages/domain/message_repository.dart';
import 'package:chambaya/features/messages/presentation/messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesViewModel extends Cubit<MessagesState> {
  final MessageRepository repository;
  final JobRepository jobRepository;
  String currentUserId = '';

  MessagesViewModel({required this.repository, required this.jobRepository})
      : super(MessagesInitial());

  Future<void> loadConversations({required String userId}) async {
    currentUserId = userId;
    emit(MessagesLoading());
    try {
      final conversations = await repository.getConversations(userId: userId);
      final enriched = await Future.wait(conversations.map((c) async {
        try {
          final job = await jobRepository.getJobById(c.jobId);
          return c.copyWith(jobTitle: job?.title);
        } catch (_) {
          return c;
        }
      }));
      emit(MessagesSuccess(conversations: enriched));
    } catch (e) {
      emit(MessagesFailure(error: 'Error al cargar mensajes'));
    }
  }
}