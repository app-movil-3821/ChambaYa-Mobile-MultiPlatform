import 'package:chambaya/features/shifts/data/shift_service.dart';
import 'package:chambaya/features/shifts/domain/shift.dart';
import 'package:chambaya/features/shifts/domain/shift_repository.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftService service;

  const ShiftRepositoryImpl({required this.service});

  @override
  Future<List<Shift>> getShiftsByWorker({required String workerId}) async {
    final dtos = await service.getShiftsByWorker(workerId: workerId);
    return dtos.map((e) => e.toDomain()).toList();
  }
}
