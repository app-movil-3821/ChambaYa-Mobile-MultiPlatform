class Conversation {
  final String id;
  final String jobId;
  final String enrollmentId;
  final String contractorId;
  final String workerId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? jobTitle;

  const Conversation({
    required this.id,
    required this.jobId,
    required this.enrollmentId,
    required this.contractorId,
    required this.workerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.jobTitle,
  });

  Conversation copyWith({String? jobTitle}) => Conversation(
    id:           id,
    jobId:        jobId,
    enrollmentId: enrollmentId,
    contractorId: contractorId,
    workerId:     workerId,
    status:       status,
    createdAt:    createdAt,
    updatedAt:    updatedAt,
    jobTitle:     jobTitle ?? this.jobTitle,
  );
}