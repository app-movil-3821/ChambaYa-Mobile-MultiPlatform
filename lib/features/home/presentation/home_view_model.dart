import 'package:chambaya/features/home/domain/job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<void> {
  final JobRepository repository;
  HomeViewModel({required this.repository}) : super(null);
}