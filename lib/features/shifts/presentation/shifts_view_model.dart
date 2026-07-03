import 'package:chambaya/core/storage/token_storage.dart';
import 'package:chambaya/features/shifts/domain/enrollment.dart';
import 'package:chambaya/features/shifts/domain/job.dart';
import 'package:chambaya/features/shifts/domain/shift_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ShiftsState {}

class ShiftsInitial   extends ShiftsState {}
class ShiftsLoading   extends ShiftsState {}
class ShiftsError     extends ShiftsState {
  final String message;
  ShiftsError(this.message);
}

class WorkerShiftsLoaded extends ShiftsState {
  final List<Enrollment> enrollments;
  WorkerShiftsLoaded(this.enrollments);
}

class ContractorShiftsLoaded extends ShiftsState {
  final List<Job> jobs;
  final Map<String, List<Enrollment>> enrollmentsByJob;
  final Set<String> expandedJobs;
  final Set<String> loadingEnrollments;

  ContractorShiftsLoaded(
    this.jobs, {
    this.enrollmentsByJob    = const {},
    this.expandedJobs        = const {},
    this.loadingEnrollments  = const {},
  });

  ContractorShiftsLoaded copyWith({
    List<Job>?                      jobs,
    Map<String, List<Enrollment>>?  enrollmentsByJob,
    Set<String>?                    expandedJobs,
    Set<String>?                    loadingEnrollments,
  }) {
    return ContractorShiftsLoaded(
      jobs               ?? this.jobs,
      enrollmentsByJob:    enrollmentsByJob   ?? this.enrollmentsByJob,
      expandedJobs:        expandedJobs       ?? this.expandedJobs,
      loadingEnrollments:  loadingEnrollments ?? this.loadingEnrollments,
    );
  }
}

class ShiftsViewModel extends Cubit<ShiftsState> {
  final ShiftRepository repository;
  final TokenStorage    tokenStorage;

  ShiftsViewModel({
    required this.repository,
    required this.tokenStorage,
  }) : super(ShiftsInitial());

  Future<void> loadShifts() async {
    emit(ShiftsLoading());
    try {
      final role = await tokenStorage.getRole();
      if (role == 'CONTRATANTE') {
        // El backend devuelve los trabajos en orden de creación ascendente;
        // se invierte para que el más reciente aparezca primero en la lista.
        final jobs = (await repository.getMyJobs()).reversed.toList();
        emit(ContractorShiftsLoaded(jobs));
      } else {
        final enrollments = await repository.getMyEnrollments();
        emit(WorkerShiftsLoaded(enrollments));
      }
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> toggleEnrollments(String jobId) async {
    final s = state;
    if (s is! ContractorShiftsLoaded) return;

    final expanded = Set<String>.from(s.expandedJobs);

    // Si ya está expandido, colapsar
    if (expanded.contains(jobId)) {
      expanded.remove(jobId);
      emit(s.copyWith(expandedJobs: expanded));
      return;
    }

    // Expandir y cargar si no están cargados
    expanded.add(jobId);
    final loading = Set<String>.from(s.loadingEnrollments)..add(jobId);
    emit(s.copyWith(expandedJobs: expanded, loadingEnrollments: loading));

    try {
      final enrollments = await repository.getEnrollmentsByJob(jobId);
      final current = state;
      if (current is ContractorShiftsLoaded) {
        final newMap = Map<String, List<Enrollment>>.from(current.enrollmentsByJob);
        newMap[jobId] = enrollments;
        final newLoading = Set<String>.from(current.loadingEnrollments)..remove(jobId);
        emit(current.copyWith(enrollmentsByJob: newMap, loadingEnrollments: newLoading));
      }
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> acceptEnrollment(String enrollmentId, String jobId) async {
    try {
      await repository.acceptEnrollment(enrollmentId);
      // Recargar postulantes del job
      final enrollments = await repository.getEnrollmentsByJob(jobId);
      final s = state;
      if (s is ContractorShiftsLoaded) {
        final newMap = Map<String, List<Enrollment>>.from(s.enrollmentsByJob);
        newMap[jobId] = enrollments;
        emit(s.copyWith(enrollmentsByJob: newMap));
      }
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> rejectEnrollment(String enrollmentId, String jobId) async {
    try {
      await repository.rejectEnrollment(enrollmentId);
      final enrollments = await repository.getEnrollmentsByJob(jobId);
      final s = state;
      if (s is ContractorShiftsLoaded) {
        final newMap = Map<String, List<Enrollment>>.from(s.enrollmentsByJob);
        newMap[jobId] = enrollments;
        emit(s.copyWith(enrollmentsByJob: newMap));
      }
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
  
  Future<void> createJob(Map<String, dynamic> data) async {
  await repository.createJob(data);
  await loadShifts();
}

  Future<void> cancelJob(String jobId) async {
    try {
      await repository.cancelJob(jobId);
      await loadShifts();
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> reopenJob(String jobId) async {
    try {
      await repository.publishJob(jobId);
      await loadShifts();
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }

  Future<void> closeJob(String jobId) async {
    try {
      await repository.closeJob(jobId);
      await loadShifts();
    } catch (e) {
      emit(ShiftsError(e.toString()));
    }
  }
}