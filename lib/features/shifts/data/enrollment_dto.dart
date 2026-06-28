import 'package:chambaya/features/shifts/data/job_dto.dart';
import 'package:chambaya/features/shifts/domain/enrollment.dart';

class EnrollmentDto {
  final String id;
  final String jobId;
  final String workerId;
  final String status;
  final String  workerName;
  final String appliedAt;
  final JobDto? job;

  const EnrollmentDto({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.workerName,
    required this.status,
    required this.appliedAt,
    this.job,
  });

  factory EnrollmentDto.fromJson(Map<String, dynamic> json) => EnrollmentDto(
    id:        json['id']       as String,
    jobId:     json['jobId']    as String,
    workerId:  json['workerId'] as String,
    workerName: json['workerName'] as String? ?? '',
    status:    json['status']   as String? ?? '',
    appliedAt: json['appliedAt'] as String? ?? '',
    job: json['job'] != null
        ? JobDto.fromJson(json['job'] as Map<String, dynamic>)
        : null,
  );

  Enrollment toDomain() => Enrollment(
    id:        id,
    jobId:     jobId,
    workerId:  workerId,
    status:    status,
    workerName: workerName,
    appliedAt: appliedAt,
    job:       job?.toDomain(),
  );
}