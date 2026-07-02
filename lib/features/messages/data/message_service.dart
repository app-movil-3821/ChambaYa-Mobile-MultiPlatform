import 'dart:convert';
import 'dart:io';

import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/messages/data/message_dto.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static const String _baseUrl =
      'https://backend-chambaya-production-a24a.up.railway.app/api/v1';

  final TokenStorage tokenStorage;

  const MessageService({required this.tokenStorage});

  Future<Map<String, String>> _headers() async {
    final token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ConversationDto>> getConversations({required String userId}) async {
  final url = '$_baseUrl/communications/user/$userId';
  print('GET $url'); 
  final response = await http.get(
    Uri.parse(url),
    headers: await _headers(),
  );
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}'); 
  if (response.statusCode == HttpStatus.ok) {
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => ConversationDto.fromJson(e)).toList();
  }
  throw Exception('Error al cargar conversaciones: ${response.statusCode}');
  } 

  Future<List<MessageDto>> getMessages({required String conversationId}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/communications/$conversationId/messages'),
      headers: await _headers(),
    );
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => MessageDto.fromJson(e)).toList();
    }
    throw Exception('Error al cargar mensajes: ${response.statusCode}');
  }

  Future<MessageDto> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/communications/$conversationId/messages'),
      headers: await _headers(),
      body: jsonEncode({'senderId': senderId, 'content': content}),
    );
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      return MessageDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al enviar mensaje: ${response.statusCode}');
  }
}