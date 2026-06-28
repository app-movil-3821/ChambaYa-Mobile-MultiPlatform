class Job {
  final String id;
  final String contractorId;
  final String title;
  final String description;
  final String category;
  final List<String> requiredSkills;
  final double paymentAmount;
  final String address;
  final String district;
  final String scheduledStart;
  final String scheduledEnd;
  final String status;

  const Job({
    required this.id,
    required this.contractorId,
    required this.title,
    required this.description,
    required this.category,
    required this.requiredSkills,
    required this.paymentAmount,
    required this.address,
    required this.district,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.status,
  });
}