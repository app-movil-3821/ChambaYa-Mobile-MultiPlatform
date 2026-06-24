import 'package:chambaya/features/home/domain/job.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeSuccess extends HomeState {
  final List<Job> jobs;

  HomeSuccess({required this.jobs});
}

class HomeFailure extends HomeState  {
  final String error;
  HomeFailure({required this.error});
}