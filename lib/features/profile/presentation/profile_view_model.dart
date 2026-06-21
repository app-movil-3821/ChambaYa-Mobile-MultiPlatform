
import 'package:chambaya/features/profile/domain/profile_repository.dart';
import 'package:chambaya/features/profile/presentation/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileViewModel({required this.repository}) : super(ProfileInitial());

  Future<void> loadProfile({required String userId}) async {
    print('loadProfile called with userId: $userId');
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile(userId: userId);
      emit(ProfileSuccess(profile: profile));
    } catch (e) {
      print('Error landing profile: $e');
      emit(ProfileFailure(error: 'Error al cargar perfil'));
    }
  }


  
  Future<void> updateProfile({
  required String userId,
  required String name,
  required String phone,
  required String district,
  required String experience,
}) async {
  emit(ProfileLoading());
  try {
    final profile = await repository.updateProfile(
      userId: userId,
      body: {
        'phone':      phone,
        'district':   district,
        'experience': experience,
        'photoUrl':   null,
        'skills':     [],
        'verified':   true,
      },
    );
    emit(ProfileSuccess(profile: profile));
  } catch (e) {
    emit(ProfileFailure(error: 'Error al actualizar perfil'));
  }
}
  
}