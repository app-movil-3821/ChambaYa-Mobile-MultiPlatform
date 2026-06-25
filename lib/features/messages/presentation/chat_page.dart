import 'package:chambaya/features/messages/presentation/chat_state.dart';
import 'package:chambaya/features/messages/presentation/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  const ChatPage({super.key, required this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: const BoxDecoration(color: Color(0xFFE8EDFB), shape: BoxShape.circle),
              child: const Center(child: Text('💼', style: TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contratante', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('En línea', style: TextStyle(fontSize: 12, color: Color(0xFF22C55E))),
              ],
            ),
          ],
        ),
      ),
      body: BlocConsumer<ChatViewModel, ChatState>(
        listener: (context, state) {
          if (state is ChatSuccess) _scrollToBottom();
        },
        builder: (context, state) {
          final messages = state is ChatSuccess ? state.messages : [];
          final senderId = context.read<ChatViewModel>().senderId;

          return Column(
            children: [
              Expanded(
                child: state is ChatLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is ChatFailure
                        ? Center(child: Text(state.error))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              final isMe = msg.senderId == senderId;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment: isMe
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (!isMe) ...[
                                      Container(
                                        width: 32, height: 32,
                                        decoration: const BoxDecoration(color: Color(0xFFE8EDFB), shape: BoxShape.circle),
                                        child: const Center(child: Text('💼', style: TextStyle(fontSize: 16))),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.65,
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isMe ? const Color(0xFF1A3FD8) : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft:     const Radius.circular(16),
                                          topRight:    const Radius.circular(16),
                                          bottomLeft:  Radius.circular(isMe ? 16 : 4),
                                          bottomRight: Radius.circular(isMe ? 4 : 16),
                                        ),
                                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                                      ),
                                      child: Text(
                                        msg.content,
                                        style: TextStyle(
                                          color: isMe ? Colors.white : const Color(0xFF0D0D0D),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),

              // Input
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Escribe un mensaje...',
                            filled: true,
                            fillColor: const Color(0xFFF0F0F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          final content = _controller.text.trim();
                          if (content.isNotEmpty) {
                            context.read<ChatViewModel>().sendMessage(content: content);
                            _controller.clear();
                          }
                        },
                        child: Container(
                          width: 44, height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A3FD8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}