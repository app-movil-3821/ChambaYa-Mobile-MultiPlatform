import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/shifts/domain/enrollment.dart';
import 'package:chambaya/features/shifts/domain/job.dart';
import 'package:chambaya/features/shifts/domain/shift_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ───────────────────────────────────────────────────────
abstract class ShiftsState {}

class ShiftsInitial extends ShiftsState {}
class ShiftsLoading extends ShiftsState {}
class ShiftsError   extends ShiftsState { final String message; ShiftsError(this.message); }

class WorkerShiftsLoaded extends ShiftsState {
  final List<Enrollment> enrollments;
  WorkerShiftsLoaded(this.enrollments);
}

class ContractorShiftsLoaded extends ShiftsState {
  final List<Job> jobs;
  ContractorShiftsLoaded(this.jobs);
}

class JobEnrollmentsLoaded extends ShiftsState {
  final List<Enrollment> enrollments;
  final String jobId;
  JobEnrollmentsLoaded(this.enrollments, this.jobId);
}

// ── Cubit ─────────────────────────────────────────────────────────
class ShiftsViewModel extends Cubit<ShiftsState> {
  final ShiftRepository repository;
  final TokenStorage tokenStorage;

  ShiftsViewModel({
    required this.repository,
    required this.tokenStorage,
  }) : super(ShiftsInitial());

  Future<void> loadShifts() async {
    emit(ShiftsLoading());
    try {
      final role = await tokenStorage.getRole();
      if (role == 'CONTRATANTE') {
        final jobs = await repository.getMyJobs();
        emit(ContractorShiftsLoaded(jobs));
      } else {
        final enrollments = await repository.getMyEnrollments();
        emit(WorkerShiftsLoaded(enrollments));
      }
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> loadEnrollmentsForJob(String jobId) async {
    emit(ShiftsLoading());
    try {
      final enrollments = await repository.getEnrollmentsByJob(jobId);
      emit(JobEnrollmentsLoaded(enrollments, jobId));
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> cancelEnrollment(String enrollmentId) async {
    try {
      await repository.cancelEnrollment(enrollmentId);
      await loadShifts();
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> publishJob(String jobId) async {
    try {
      await repository.publishJob(jobId);
      await loadShifts();
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> startJob(String jobId) async {
    try {
      await repository.startJob(jobId);
      await loadShifts();
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> completeJob(String jobId) async {
    try {
      await repository.completeJob(jobId);
      await loadShifts();
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> cancelJob(String jobId) async {
    try {
      await repository.cancelJob(jobId);
      await loadShifts();
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> acceptEnrollment(String enrollmentId, String jobId) async {
    try {
      await repository.acceptEnrollment(enrollmentId);
      await loadEnrollmentsForJob(jobId);
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> rejectEnrollment(String enrollmentId, String jobId) async {
    try {
      await repository.rejectEnrollment(enrollmentId);
      await loadEnrollmentsForJob(jobId);
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }
}