import 'package:chambaya/features/home/data/job_service.dart';
import 'package:chambaya/features/home/domain/job.dart';
import 'package:chambaya/features/home/domain/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobService service;
  const JobRepositoryImpl({required this.service});

  @override
  Future<List<Job>> getPublishedJobs() {
    return service.getPublishedJobs();
  }
}