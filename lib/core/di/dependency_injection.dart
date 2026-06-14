import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/auth/data/auth_repository_impl.dart';
import 'package:chambaya/features/auth/data/auth_service.dart';
import 'package:chambaya/features/auth/domain/auth_repository.dart';
import 'package:chambaya/features/auth/presentation/login_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<TokenStorage>(
    () => TokenStorage(storage: getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<AuthService>(() => AuthService());

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      service:      getIt<AuthService>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  getIt.registerFactory(
    () => LoginViewModel(repository: getIt<AuthRepository>()),
  );
}