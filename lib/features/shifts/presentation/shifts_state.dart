import 'package:chambaya/features/home/domain/job.dart';
import 'package:chambaya/features/shifts/domain/shift.dart';

class ShiftWithJob {
  final Shift shift;
  final Job? job;
  const ShiftWithJob({required this.shift, this.job});
}

sealed class ShiftsState {}

class ShiftsInitial extends ShiftsState {}

class ShiftsLoading extends ShiftsState {}

class ShiftsSuccess extends ShiftsState {
  final List<ShiftWithJob> shifts;
  ShiftsSuccess({required this.shifts});
}

class ShiftsFailure extends ShiftsState {
  final String error;
  ShiftsFailure({required this.error});
}
