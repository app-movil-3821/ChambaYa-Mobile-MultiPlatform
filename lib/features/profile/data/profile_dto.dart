import 'package:chambaya/features/profile/domain/profile.dart';

class ProfileDto {
  final String id;
  final String name;
  final String email;
  final String role;
  final ProfileDataDto? profile;

  const ProfileDto({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profile,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      id:      json['id']    as String,
      name:    json['name']  as String,
      email:   json['email'] as String,
      role:    json['role']  as String,
      profile: json['profile'] != null
          ? ProfileDataDto.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Profile toDomain() => Profile(
    id:         id,
    name:       name,
    email:      email,
    role:       role,
    phone:      profile?.phone      ?? '',
    skills:     profile?.skills     ?? [],
    experience: profile?.experience ?? '',
    district:   profile?.district   ?? '',
    photoUrl:   profile?.photoUrl,
    verified:   profile?.verified   ?? false,
  );
}

class ProfileDataDto {
  final String? photoUrl;
  final List<String> skills;
  final String experience;
  final String district;
  final String phone;
  final bool verified;

  const ProfileDataDto({
    this.photoUrl,
    required this.skills,
    required this.experience,
    required this.district,
    required this.phone,
    required this.verified,
  });

  factory ProfileDataDto.fromJson(Map<String, dynamic> json) {
    return ProfileDataDto(
      photoUrl:   json['photoUrl']   as String?,
      skills:     List<String>.from(json['skills'] ?? []),
      experience: json['experience'] as String? ?? '',
      district:   json['district']   as String? ?? '',
      phone:      json['phone']      as String? ?? '',
      verified:   json['verified']   as bool?   ?? false,
    );
  }
}