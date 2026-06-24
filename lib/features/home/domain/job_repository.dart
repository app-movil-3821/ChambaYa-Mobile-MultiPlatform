import 'package:chambaya/features/home/domain/job.dart';

abstract class JobRepository {
  Future<List<Job>> getPublishedJobs();

  Future<void> applyToJob(Job job);
}