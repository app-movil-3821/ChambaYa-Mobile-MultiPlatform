import 'dart:convert';
import 'dart:io';

import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/profile/data/profile_dto.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static const String _baseUrl =
      'https://backend-chambaya-production-b2e5.up.railway.app/api/v1';

  final TokenStorage tokenStorage;

  const ProfileService({required this.tokenStorage});

  Future<Map<String, String>> _headers() async {
    final token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ProfileDto> getProfile({required String userId}) async {
    final url = '$_baseUrl/users/$userId';
    print('GET $url');

    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == HttpStatus.ok) {
      return ProfileDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error: ${response.statusCode} - ${response.body}');
  }

  Future<ProfileDto> updateProfile({
    required String userId,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$userId/profile'),
      headers: await _headers(),
      body:    jsonEncode(body),
    );

    print('Update status: ${response.statusCode}');
    print('Update body: ${response.body}');

    if (response.statusCode == HttpStatus.ok) {
      return ProfileDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al actualizar perfil: ${response.statusCode}');
  }
}