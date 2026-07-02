import 'package:chambaya/features/auth/domain/auth_repository.dart';
import 'package:chambaya/features/auth/domain/user.dart';
import 'package:chambaya/features/auth/presentation/register_state.dart';
import 'package:chambaya/features/profile/domain/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterViewModel extends Cubit<RegisterState> {
  final AuthRepository repository;
  final ProfileRepository profileRepository;

  RegisterViewModel({required this.repository, required this.profileRepository})
      : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
    List<String> skills = const [],
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      emit(RegisterFailure(error: 'Completa todos los campos'));
      return;
    }
    if (password.length < 6) {
      emit(RegisterFailure(error: 'La contraseña debe tener al menos 6 caracteres'));
      return;
    }
    if (role == 'CHAMBEADOR' && skills.isEmpty) {
      emit(RegisterFailure(error: 'Selecciona al menos una habilidad'));
      return;
    }

    emit(RegisterLoading());
    try {
      final User user = await repository.register(
        name:     name,
        email:    email,
        password: password,
        phone:    phone,
        role:     role,
      );

      if (role == 'CHAMBEADOR') {
        // El registro no devuelve token; iniciamos sesión para poder
        // guardar las habilidades en el endpoint autenticado del perfil.
        await repository.login(email: email, password: password);
        await profileRepository.updateProfile(
          userId: user.id,
          body:   {'skills': skills, 'verified': false},
        );
      }

      emit(RegisterSuccess(user: user));
    } catch (e) {
      emit(RegisterFailure(error: 'No se pudo completar el registro. Intenta de nuevo.'));
    }
  }
}
