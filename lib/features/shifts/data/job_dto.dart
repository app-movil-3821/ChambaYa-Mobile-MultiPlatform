import 'package:chambaya/features/shifts/domain/job.dart';

class JobDto {
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

  const JobDto({
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

  factory JobDto.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    return JobDto(
      id:             json['id']           as String,
      contractorId:   json['contractorId'] as String,
      title:          json['title']        as String,
      description:    json['description']  as String? ?? '',
      category:       json['category']     as String? ?? '',
      requiredSkills: (json['requiredSkills'] as List<dynamic>?)
                          ?.map((e) => e as String).toList() ?? [],
      paymentAmount:  (json['paymentAmount'] as num).toDouble(),
      address:        location?['address']  as String? ?? '',
      district:       location?['district'] as String? ?? '',
      scheduledStart: json['scheduleStart'] as String? ?? '',
      scheduledEnd:   json['scheduleEnd']   as String? ?? '',
      status:         json['status']        as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'contractorId':   contractorId,
    'title':          title,
    'description':    description,
    'category':       category,
    'requiredSkills': requiredSkills,
    'paymentAmount':  paymentAmount,
    'address':        address,
    'district':       district,
    'scheduledStart': scheduledStart,
    'scheduledEnd':   scheduledEnd,
  };

  Job toDomain() => Job(
    id:             id,
    contractorId:   contractorId,
    title:          title,
    description:    description,
    category:       category,
    requiredSkills: requiredSkills,
    paymentAmount:  paymentAmount,
    address:        address,
    district:       district,
    scheduledStart: scheduledStart,
    scheduledEnd:   scheduledEnd,
    status:         status,
  );
}