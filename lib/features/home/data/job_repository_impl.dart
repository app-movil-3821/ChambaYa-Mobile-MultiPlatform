import 'package:chambaya/features/home/data/job_service.dart';
import 'package:chambaya/features/home/domain/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobService service;
  const JobRepositoryImpl({required this.service});
}