import 'dart:convert';
import 'dart:io';
import 'package:chambaya/features/shifts/data/enrollment_dto.dart';
import 'package:chambaya/features/shifts/data/job_dto.dart';
import 'package:http/http.dart' as http;

class ShiftService {
  static const String _baseUrl =
    'https://backend-chambaya-production-a24a.up.railway.app/api/v1';

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // ── JOBS (Contratante) ───────────────────────────────────────

  Future<List<JobDto>> getJobsByContractor(String contractorId, String token) async {
    print('URL: $_baseUrl/jobs/contractor/$contractorId'); // ← AGREGA ESTO
    print('Token: $token'); // ← Y ESTO
    final res = await http.get(
      Uri.parse('$_baseUrl/jobs/contractor/$contractorId'),
      headers: _headers(token),
    );
     print('Status: ${res.statusCode}'); // ← Y ESTO
    print('Body: ${res.body}'); // ← Y ESTO
    if (res.statusCode == HttpStatus.ok) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list.map((e) => JobDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener trabajos: ${res.statusCode}');
  }

  Future<JobDto> createJob(Map<String, dynamic> body, String token) async {
    print('Create job body: ${jsonEncode(body)}');
    final res = await http.post(
      Uri.parse('$_baseUrl/jobs'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    print('Create job status: ${res.statusCode}');
    print('Create job response: ${res.body}');
    if (res.statusCode == HttpStatus.ok || res.statusCode == HttpStatus.created) {
      return JobDto.fromJson(jsonDecode(res.body));
    }
    throw Exception('Error al crear trabajo: ${res.statusCode}');
  }

  Future<void> publishJob(String jobId, String token) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/jobs/$jobId/publish'),
      headers: _headers(token),
    );
    if (res.statusCode != HttpStatus.ok) {
      throw Exception('Error al publicar: ${res.statusCode}');
    }
  }

  Future<void> startJob(String jobId, String token) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/jobs/$jobId/start'),
      headers: _headers(token),
    );
    if (res.statusCode != HttpStatus.ok) {
      throw Exception('Error al iniciar: ${res.statusCode}');
    }
  }

  Future<String> getUserName(String userId, String token) async {
  final res = await http.get(
    Uri.parse('$_baseUrl/users/$userId'),
    headers: _headers(token),
  );
  if (res.statusCode == HttpStatus.ok) {
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return json['name'] as String? ?? userId;
  }
  return userId; 
}


  Future<void> closeJob(String jobId, String token) async {
  final res = await http.put(
    Uri.parse('$_baseUrl/jobs/$jobId/close'),
    headers: _headers(token),
  );
  if (res.statusCode != HttpStatus.ok) {
    throw Exception('Error al cerrar: ${res.statusCode}');
  }
}

  Future<void> completeJob(String jobId, String token) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/jobs/$jobId/complete'),
      headers: _headers(token),
    );
    if (res.statusCode != HttpStatus.ok) {
      throw Exception('Error al completar: ${res.statusCode}');
    }
  }

  Future<void> cancelJob(String jobId, String token) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/jobs/$jobId/cancel'),
      headers: _headers(token),
    );
    if (res.statusCode != HttpStatus.ok) {
      throw Exception('Error al cancelar: ${res.statusCode}');
    }
  }

  // ── ENROLLMENTS (Chambeador) ─────────────────────────────────

  Future<List<EnrollmentDto>> getEnrollmentsByWorker(String workerId, String token) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/enrollments/worker/$workerId'),
      headers: _headers(token),
    );
    if (res.statusCode == HttpStatus.ok) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list.map((e) => EnrollmentDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener turnos: ${res.statusCode}');
  }

  Future<void> cancelEnrollment(String enrollmentId, String token) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/enrollments/$enrollmentId/cancel'),
      headers: _headers(token),
    );
    if (res.statusCode != HttpStatus.ok) {
      throw Exception('Error al cancelar postulación: ${res.statusCode}');
    }
  }

  // ── ENROLLMENTS (Contratante) ────────────────────────────────

  Future<List<EnrollmentDto>> getEnrollmentsByJob(String jobId, String token) async {

    print('Enrollments URL: $_baseUrl/enrollments/job/$jobId');
    final res = await http.get(
      Uri.parse('$_baseUrl/enrollments/job/$jobId'),
      headers: _headers(token),
    );
    print('Enrollments Status: ${res.statusCode}');
    print('Enrollments Body: ${res.body}');
    if (res.statusCode == HttpStatus.ok) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list.map((e) => EnrollmentDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error: ${res.statusCode}');
  }

  Future<void> acceptEnrollment(String enrollmentId, String token) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/enrollments/$enrollmentId/accept'),
      headers: _headers(token),
    );
    if (res.statusCode != HttpStatus.ok) {
      throw Exception('Error al aceptar: ${res.statusCode}');
    }
  }

  Future<JobDto> getJobById(String jobId, String token) async {
  final res = await http.get(
    Uri.parse('$_baseUrl/jobs/$jobId'),
    headers: _headers(token),
  );
  if (res.statusCode == HttpStatus.ok) {
    return JobDto.fromJson(jsonDecode(res.body));
  }
  throw Exception('Error al obtener job: ${res.statusCode}');
}

  Future<void> rejectEnrollment(String enrollmentId, String token) async {
    final res = await http.put(
      Uri.parse('$_baseUrl/enrollments/$enrollmentId/reject'),
      headers: _headers(token),
    );
    if (res.statusCode != HttpStatus.ok) {
      throw Exception('Error al rechazar: ${res.statusCode}');
    }
  }
}
