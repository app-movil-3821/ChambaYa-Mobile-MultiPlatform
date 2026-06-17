import 'dart:convert';

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

    if (token == null || token.isEmpty) {
      throw Exception('No hay token de sesión. Inicia sesión nuevamente.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/jobs/published'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as List<dynamic>;

      return decoded
          .map((item) => Job.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Error al cargar trabajos: ${response.statusCode}');
  }

  Future<void> applyToJob(Job job) async {
    final token = await tokenStorage.getToken();
    final userId = await tokenStorage.getUserId();

    if (token == null || token.isEmpty) {
      throw Exception('No hay token de sesión. Inicia sesión nuevamente.');
    }

    if (userId == null || userId.isEmpty) {
      throw Exception('No se encontró el usuario logueado.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/enrollments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'jobId': job.id,
        'workerId': userId,
        'contractorId': job.contractorId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    throw Exception(
      'Error al postular: ${response.statusCode} - ${response.body}',
    );
  }
}