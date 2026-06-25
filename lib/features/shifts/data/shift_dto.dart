import 'package:chambaya/features/shifts/domain/shift.dart';

class ShiftDto {
  final String id;
  final String jobId;
  final String workerId;
  final String contractorId;
  final String status;
  final String appliedAt;

  const ShiftDto({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.contractorId,
    required this.status,
    required this.appliedAt,
  });

  factory ShiftDto.fromJson(Map<String, dynamic> json) {
    return ShiftDto(
      id:           json['id']?.toString()           ?? '',
      jobId:        json['jobId']?.toString()        ?? '',
      workerId:     json['workerId']?.toString()     ?? '',
      contractorId: json['contractorId']?.toString() ?? '',
      status:       json['status']?.toString()       ?? '',
      appliedAt:    json['appliedAt']?.toString()    ?? '',
    );
  }

  Shift toDomain() => Shift(
    id:           id,
    jobId:        jobId,
    workerId:     workerId,
    contractorId: contractorId,
    status:       status,
    appliedAt:    appliedAt,
  );
}
