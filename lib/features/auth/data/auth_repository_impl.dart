import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/auth/data/auth_service.dart';
import 'package:chambaya/features/auth/data/login_request_dto.dart';
import 'package:chambaya/features/auth/data/register_request_dto.dart';
import 'package:chambaya/features/auth/domain/auth_repository.dart';
import 'package:chambaya/features/auth/domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  final TokenStorage tokenStorage;

  const AuthRepositoryImpl({
    required this.service,
    required this.tokenStorage,
  });

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final dto = LoginRequestDto(email: email, password: password);
    final response = await service.login(dto);
    print('TOKEN: ${response.token}');  // ← AGREGA ESTO
    await tokenStorage.saveToken(response.token);
    await tokenStorage.saveUserId(response.userId);
    await tokenStorage.saveRole(response.role);
    return response.toDomain();
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final dto = RegisterRequestDto(
      name:     name,
      email:    email,
      password: password,
      phone:    phone,
    );
    final json = await service.register(dto);
    return User(
      id:    json['id']    as String,
      name:  json['name']  as String,
      email: json['email'] as String,
      role:  json['role']  as String,
    );
  }
}