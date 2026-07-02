import 'package:chambaya/features/auth/domain/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String role = 'CHAMBEADOR',
  });
}