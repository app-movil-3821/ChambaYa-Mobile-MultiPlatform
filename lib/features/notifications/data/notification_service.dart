import 'dart:convert';
import 'dart:io';

import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/notifications/data/notification_dto.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String _baseUrl =
      'https://backend-chambaya-production-a24a.up.railway.app/api/v1';

  final TokenStorage tokenStorage;

  const NotificationService({required this.tokenStorage});

  Future<Map<String, String>> _headers() async {
    final token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<NotificationDto>> getByUser(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/notifications/user/$userId'),
      headers: await _headers(),
    );
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => NotificationDto.fromJson(e)).toList();
    }
    throw Exception('Error al cargar notificaciones: ${response.statusCode}');
  }

  Future<List<NotificationDto>> getUnreadByUser(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/notifications/user/$userId/unread'),
      headers: await _headers(),
    );
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => NotificationDto.fromJson(e)).toList();
    }
    throw Exception('Error al cargar notificaciones: ${response.statusCode}');
  }

  Future<void> markAsRead(String notificationId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/notifications/$notificationId/read'),
      headers: await _headers(),
    );
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Error al marcar como leída: ${response.statusCode}');
    }
  }

  Future<void> markAllAsRead(String userId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/notifications/user/$userId/read-all'),
      headers: await _headers(),
    );
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Error al marcar todas como leídas: ${response.statusCode}');
    }
  }
}
