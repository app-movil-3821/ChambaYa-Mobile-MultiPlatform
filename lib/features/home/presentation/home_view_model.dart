import 'package:chambaya/features/home/domain/job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chambaya/features/home/presentation/home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  final JobRepository repository;
  HomeViewModel({required this.repository}) : super(HomeInitial());

  Future<void> loadPublishedJobs() async{
    emit(HomeLoading());
    try {
      final jobs = await repository.getPublishedJobs();
      emit(HomeSuccess(jobs: jobs));
    } catch (e) {
      emit(HomeFailure(error: e.toString()));
    }
  }
}