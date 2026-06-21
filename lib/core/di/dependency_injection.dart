import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/auth/data/auth_repository_impl.dart';
import 'package:chambaya/features/auth/data/auth_service.dart';
import 'package:chambaya/features/auth/domain/auth_repository.dart';
import 'package:chambaya/features/auth/presentation/login_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chambaya/features/home/data/job_repository_impl.dart';
import 'package:chambaya/features/home/data/job_service.dart';
import 'package:chambaya/features/home/domain/job_repository.dart';
import 'package:chambaya/features/home/presentation/home_view_model.dart';
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

  getIt.registerLazySingleton<JobService>(
    () => JobService(tokenStorage: getIt<TokenStorage>()),
  );

  getIt.registerLazySingleton<JobRepository>(
    () => JobRepositoryImpl(service: getIt<JobService>()),
  );

  getIt.registerFactory(
    () => HomeViewModel(repository: getIt<JobRepository>()),
  );

  getIt.registerFactory(
    () => LoginViewModel(repository: getIt<AuthRepository>()),
  );
}