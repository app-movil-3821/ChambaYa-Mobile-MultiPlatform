import 'dart:convert';
import 'dart:io';

import 'package:chambaya/features/auth/data/login_request_dto.dart';
import 'package:chambaya/features/auth/data/login_response_dto.dart';
import 'package:chambaya/features/auth/data/register_request_dto.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl =
      'https://backend-chambaya-production-b2e5.up.railway.app/api/v1';

  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      return LoginResponseDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al iniciar sesión: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> register(RegisterRequestDto dto) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      return jsonDecode(response.body);
    }
    throw Exception('Error al registrarse: ${response.statusCode}');
  }
}