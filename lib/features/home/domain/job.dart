class Job {
  final String id;
  final String contractorId;
  final String title;
  final String description;
  final String category;
  final List<String> requiredSkills;
  final double paymentAmount;
  final double latitude;
  final double longitude;
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
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.district,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.status,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    final location = json['location'];

    return Job(
      id: json['id']?.toString() ?? '',
      contractorId: json['contractorId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      requiredSkills: (json['requiredSkills'] as List<dynamic>? ?? [])
          .map((skill) => skill.toString())
          .toList(),
      paymentAmount: (json['paymentAmount'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble()
          ?? (location is Map<String, dynamic>
              ? (location['latitude'] as num?)?.toDouble()
              : null)
          ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble()
          ?? (location is Map<String, dynamic>
              ? (location['longitude'] as num?)?.toDouble()
              : null)
          ?? 0.0,
      address: json['address']?.toString()
          ?? (location is Map<String, dynamic>
              ? location['address']?.toString()
              : null)
          ?? '',
      district: json['district']?.toString()
          ?? (location is Map<String, dynamic>
              ? location['district']?.toString()
              : null)
          ?? '',
      scheduledStart: json['scheduledStart']?.toString()
          ?? json['scheduleStart']?.toString()
          ?? '',
      scheduledEnd: json['scheduledEnd']?.toString()
          ?? json['scheduleEnd']?.toString()
          ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}