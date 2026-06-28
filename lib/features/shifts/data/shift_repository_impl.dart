import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/shifts/data/shift_service.dart';
import 'package:chambaya/features/shifts/domain/enrollment.dart';
import 'package:chambaya/features/shifts/domain/job.dart';
import 'package:chambaya/features/shifts/domain/shift_repository.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftService service;
  final TokenStorage tokenStorage;

  const ShiftRepositoryImpl({
    required this.service,
    required this.tokenStorage,
  });

  Future<String> _token() async {
    final token = await tokenStorage.getToken();
    if (token == null) throw Exception('No autenticado');
    return token;
  }

  Future<String> _userId() async {
    final id = await tokenStorage.getUserId();
    if (id == null) throw Exception('Usuario no encontrado');
    return id;
  }

  // ── Chambeador ───────────────────────────────────────────────

  @override
  Future<List<Enrollment>> getMyEnrollments() async {
    final token    = await _token();
    final workerId = await _userId();
    final dtos     = await service.getEnrollmentsByWorker(workerId, token);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> cancelEnrollment(String enrollmentId) async {
    final token = await _token();
    await service.cancelEnrollment(enrollmentId, token);
  }

  // ── Contratante ──────────────────────────────────────────────

  @override
  Future<List<Job>> getMyJobs() async {
    final token        = await _token();
    final contractorId = await _userId();
    final dtos         = await service.getJobsByContractor(contractorId, token);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Job> createJob(Map<String, dynamic> data) async {
    final token = await _token();
    final dto   = await service.createJob(data, token);
    return dto.toDomain();
  }

  @override
  Future<void> publishJob(String jobId) async =>
      service.publishJob(jobId, await _token());

  @override
  Future<void> startJob(String jobId) async =>
      service.startJob(jobId, await _token());

  @override
  Future<void> completeJob(String jobId) async =>
      service.completeJob(jobId, await _token());

  @override
  Future<void> cancelJob(String jobId) async =>
      service.cancelJob(jobId, await _token());

@override
Future<List<Enrollment>> getEnrollmentsByJob(String jobId) async {
  final token = await _token();
  final dtos  = await service.getEnrollmentsByJob(jobId, token);

  // Obtener nombre de cada worker
  final enrollments = await Future.wait(
    dtos.map((dto) async {
      final name = await service.getUserName(dto.workerId, token);
      return Enrollment(
        id:         dto.id,
        jobId:      dto.jobId,
        workerId:   dto.workerId,
        workerName: name,
        status:     dto.status,
        appliedAt:  dto.appliedAt,
        job:        dto.job?.toDomain(),
      );
    }),
  );

  return enrollments;
}

  @override
  Future<void> closeJob(String jobId) async =>
    service.closeJob(jobId, await _token());

  @override
  Future<void> acceptEnrollment(String enrollmentId) async =>
      service.acceptEnrollment(enrollmentId, await _token());

  @override
  Future<void> rejectEnrollment(String enrollmentId) async =>
      service.rejectEnrollment(enrollmentId, await _token());
}