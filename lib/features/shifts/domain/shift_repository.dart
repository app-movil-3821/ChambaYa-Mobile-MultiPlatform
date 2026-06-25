import 'package:chambaya/features/shifts/domain/shift.dart';

abstract class ShiftRepository {
  Future<List<Shift>> getShiftsByWorker({required String workerId});
}
