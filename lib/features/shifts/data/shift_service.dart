import 'dart:convert';
import 'dart:io';

import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/shifts/data/shift_dto.dart';
import 'package:http/http.dart' as http;

class ShiftService {
  static const String _baseUrl =
      'https://backend-chambaya-production-a24a.up.railway.app/api/v1';

  final TokenStorage tokenStorage;

  const ShiftService({required this.tokenStorage});

  Future<Map<String, String>> _headers() async {
    final token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ShiftDto>> getShiftsByWorker({required String workerId}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/enrollments/worker/$workerId'),
      headers: await _headers(),
    );
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => ShiftDto.fromJson(e)).toList();
    }
    throw Exception('Error al cargar turnos: ${response.statusCode}');
  }
}
