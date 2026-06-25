class Conversation {
  final String id;
  final String jobId;
  final String enrollmentId;
  final String contractorId;
  final String workerId;
  final String status;
  final String createdAt;
  final String updatedAt;

  const Conversation({
    required this.id,
    required this.jobId,
    required this.enrollmentId,
    required this.contractorId,
    required this.workerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}