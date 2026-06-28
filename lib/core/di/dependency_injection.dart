import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/auth/data/auth_repository_impl.dart';
import 'package:chambaya/features/auth/data/auth_service.dart';
import 'package:chambaya/features/auth/domain/auth_repository.dart';
import 'package:chambaya/features/auth/presentation/login_view_model.dart';
import 'package:chambaya/features/home/data/job_repository_impl.dart';
import 'package:chambaya/features/home/data/job_service.dart';
import 'package:chambaya/features/home/domain/job_repository.dart';
import 'package:chambaya/features/home/presentation/home_view_model.dart';
import 'package:chambaya/features/profile/data/profile_repository_impl.dart';
import 'package:chambaya/features/profile/data/profile_service.dart';
import 'package:chambaya/features/profile/domain/profile_repository.dart';
import 'package:chambaya/features/profile/presentation/profile_view_model.dart';
import 'package:chambaya/features/messages/data/message_repository_impl.dart';
import 'package:chambaya/features/messages/data/message_service.dart';
import 'package:chambaya/features/messages/domain/message_repository.dart';
import 'package:chambaya/features/messages/presentation/messages_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get_it/get_it.dart';

import 'package:chambaya/features/shifts/data/shift_repository_impl.dart';
import 'package:chambaya/features/shifts/data/shift_service.dart';
import 'package:chambaya/features/shifts/domain/shift_repository.dart';
import 'package:chambaya/features/shifts/presentation/shifts_view_model.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<TokenStorage>(
    () => TokenStorage(storage: getIt<FlutterSecureStorage>()),
  );

  // Auth
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

  // Home
  getIt.registerLazySingleton<JobService>(
    () => JobService(tokenStorage: getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<JobRepository>(
    () => JobRepositoryImpl(service: getIt<JobService>()),
  );
  getIt.registerFactory(
    () => HomeViewModel(repository: getIt<JobRepository>()),
  );

  // Profile
  getIt.registerLazySingleton<ProfileService>(
    () => ProfileService(tokenStorage: getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(service: getIt<ProfileService>()),
  );
  getIt.registerFactory(
    () => ProfileViewModel(repository: getIt<ProfileRepository>()),
  );

  // Messages
  getIt.registerLazySingleton<MessageService>(
    () => MessageService(tokenStorage: getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(service: getIt<MessageService>()),
  );
  getIt.registerFactory(
    () => MessagesViewModel(repository: getIt<MessageRepository>()),
  );

  // Shifts
  getIt.registerLazySingleton<ShiftService>(() => ShiftService());
  getIt.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(
      service:      getIt<ShiftService>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );
  getIt.registerFactory(
    () => ShiftsViewModel(
      repository:   getIt<ShiftRepository>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

}