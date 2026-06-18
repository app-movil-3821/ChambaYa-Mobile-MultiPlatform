import 'dart:convert';
import 'dart:io';

import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/home/domain/job.dart';
import 'package:http/http.dart' as http;


class JobService {
  static const String _baseUrl =
      'https://backend-chambaya-production-b2e5.up.railway.app/api/v1';

  final TokenStorage tokenStorage;
  const JobService({required this.tokenStorage});

  Future<List<Job>> getPublishedJobs() async {
    final token = await tokenStorage.getToken();

    if(token == null || token.isEmpty) {
      throw Exception('No hay token de sesion. Inicia sesion nuevamente.');
    }
     final response = await http.get(
      Uri.parse('$_baseUrl/jobs/published'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      final decoded = jsonDecode(response.body) as List<dynamic>;

      return decoded
          .map((item) => Job.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Error al cargar trabajos: ${response.statusCode}');
  }


}