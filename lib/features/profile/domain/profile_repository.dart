import 'package:chambaya/features/profile/domain/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile({required String userId});
  Future<Profile> updateProfile({
    required String userId,
    required Map<String, dynamic> body,
  });
}