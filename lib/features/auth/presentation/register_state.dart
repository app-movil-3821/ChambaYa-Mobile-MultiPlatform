import 'package:chambaya/features/auth/domain/user.dart';

sealed class RegisterState {}
class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {
  final User user;
  RegisterSuccess({required this.user});
}
class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure({required this.error});
}
