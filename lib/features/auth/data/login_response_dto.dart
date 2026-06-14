import 'package:chambaya/features/auth/domain/user.dart';

class LoginResponseDto {
  final String token;
  final String userId;
  final String name;
  final String email;
  final String role;
  const LoginResponseDto({required this.token, required this.userId, required this.name, required this.email, required this.role});
  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => LoginResponseDto(
    token: json['token'], userId: json['userId'], name: json['name'], email: json['email'], role: json['role'],
  );
  User toDomain() => User(id: userId, name: name, email: email, role: role);
}