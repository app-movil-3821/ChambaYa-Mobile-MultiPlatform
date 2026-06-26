import 'package:chambaya/features/shifts/domain/job.dart';

class Enrollment {
  final String id;
  final String jobId;
  final String workerId;
  final String status;
  final String  workerName;
  final String appliedAt;
  final Job? job; // populated cuando se necesite

  const Enrollment({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.workerName,
    required this.status,
    required this.appliedAt,
    this.job,
  });
}