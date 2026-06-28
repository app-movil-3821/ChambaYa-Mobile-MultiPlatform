
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final String _tokenKey  = 'auth_token';
  final String _userIdKey = 'user_id';
    final String _roleKey   = 'user_role';  

  final FlutterSecureStorage _storage;

  const TokenStorage({required FlutterSecureStorage storage})
      : _storage = storage;

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

    Future<void> saveRole(String role) async =>       
      await _storage.write(key: _roleKey, value: role);

  Future<String?> getRole() async =>               
      await _storage.read(key: _roleKey);

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}