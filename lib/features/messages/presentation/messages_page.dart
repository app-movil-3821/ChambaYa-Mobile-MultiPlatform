import 'package:chambaya/features/messages/domain/conversation.dart';
import 'package:chambaya/features/messages/presentation/chat_view_model.dart';
import 'package:chambaya/features/messages/presentation/messages_state.dart';
import 'package:chambaya/features/messages/presentation/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: BlocBuilder<MessagesViewModel, MessagesState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                title: const Text('Mensajes',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0D0D0D))),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar conversación...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF0F0F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              if (state is MessagesLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is MessagesFailure)
                SliverFillRemaining(child: Center(child: Text(state.error)))
              else if (state is MessagesSuccess && state.conversations.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No tienes conversaciones aún',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else if (state is MessagesSuccess)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final conv = state.conversations[index];
                      return _ConversationTile(
                        conversation: conv,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => ChatViewModel(
                                repository:     context.read<MessagesViewModel>().repository,
                                conversationId: conv.id,
                                senderId:       conv.workerId,
                                )..loadMessages(),
                                child: ChatPage(conversationId: conv.id),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: state.conversations.length,
                  ),
                )
              else
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48, height: 48,
          decoration: const BoxDecoration(color: Color(0xFFE8EDFB), shape: BoxShape.circle),
          child: const Center(child: Text('💼', style: TextStyle(fontSize: 24))),
        ),
        title: Text(
          'Trabajo ${conversation.jobId.length > 6 ? conversation.jobId.substring(0, 6) : conversation.jobId}...',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          conversation.status == 'ACTIVE' ? 'Conversación activa' : 'Cerrada',
          style: TextStyle(
            color: conversation.status == 'ACTIVE' ? const Color(0xFF22C55E) : Colors.grey,
            fontSize: 13,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}