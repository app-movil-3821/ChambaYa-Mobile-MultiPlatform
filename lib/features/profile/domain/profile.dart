class Profile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final List<String> skills;
  final String experience;
  final String district;
  final String? photoUrl;
  final bool verified;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.skills,
    required this.experience,
    required this.district,
    this.photoUrl,
    required this.verified,
  });
}