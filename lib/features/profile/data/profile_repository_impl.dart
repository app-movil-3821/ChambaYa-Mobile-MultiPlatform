import 'package:chambaya/features/profile/data/profile_service.dart';
import 'package:chambaya/features/profile/domain/profile.dart';
import 'package:chambaya/features/profile/domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService service;

  const ProfileRepositoryImpl({required this.service});

  @override
  Future<Profile> getProfile({required String userId}) async {
    final dto = await service.getProfile(userId: userId);
    return dto.toDomain();
  }

  @override
  Future<Profile> updateProfile({
    required String userId,
    required String name,
    required String phone,
    required String district,
    required String experience,
  }) async {
    final dto = await service.updateProfile(
      userId: userId,
      body: {
        'name':       name,
        'phone':      phone,
        'district':   district,
        'experience': experience,
      },
    );
    return dto.toDomain();
  }
}