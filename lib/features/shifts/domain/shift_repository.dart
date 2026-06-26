import 'package:chambaya/features/shifts/domain/enrollment.dart';
import 'package:chambaya/features/shifts/domain/job.dart';

abstract class ShiftRepository {
  // Chambeador
  Future<List<Enrollment>> getMyEnrollments();
  Future<void> cancelEnrollment(String enrollmentId);

  // Contratante
  Future<List<Job>> getMyJobs();
  Future<Job> createJob(Map<String, dynamic> data);
  Future<void> publishJob(String jobId);
  Future<void> startJob(String jobId);
  Future<void> completeJob(String jobId);
  Future<void> closeJob(String jobId);
  Future<void> cancelJob(String jobId);
  Future<List<Enrollment>> getEnrollmentsByJob(String jobId);
  Future<void> acceptEnrollment(String enrollmentId);
  Future<void> rejectEnrollment(String enrollmentId);
}