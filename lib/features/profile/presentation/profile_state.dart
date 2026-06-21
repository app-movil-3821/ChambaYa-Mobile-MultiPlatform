
import 'package:chambaya/features/profile/domain/profile.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Profile profile;
  ProfileSuccess({required this.profile});
}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure({required this.error});
}