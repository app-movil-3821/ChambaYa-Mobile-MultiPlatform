import 'package:chambaya/features/home/domain/job.dart';
import 'package:chambaya/features/home/presentation/help_page.dart';
import 'package:flutter/material.dart';

class ActiveShiftPage extends StatelessWidget {
  final Job job;

  const ActiveShiftPage({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      appBar: AppBar(
        title: const Text(
          'Turno en progreso',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202124),
        elevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HelpPage(job: job),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2146E8),
                    side: const BorderSide(color: Color(0xFF2146E8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text(
                    'Pedir ayuda',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Llegada confirmada.'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2146E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text(
                    'Confirmar llegada',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFC9D6FF)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.work_history_outlined,
                    size: 64,
                    color: Color(0xFF2146E8),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tu turno está activo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF202124),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    job.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE1E4EC)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles del turno',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF202124),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _ActiveShiftRow(
                      icon: Icons.location_on_outlined,
                      title: 'Ubicación',
                      value: _formatLocation(job),
                    ),

                    const SizedBox(height: 14),

                    _ActiveShiftRow(
                      icon: Icons.schedule_outlined,
                      title: 'Horario',
                      value: _formatSchedule(job),
                    ),

                    const SizedBox(height: 14),

                    _ActiveShiftRow(
                      icon: Icons.payments_outlined,
                      title: 'Pago estimado',
                      value: 'S/ ${job.paymentAmount.toStringAsFixed(2)}',
                    ),

                    const SizedBox(height: 14),

                    _ActiveShiftRow(
                      icon: Icons.category_outlined,
                      title: 'Categoría',
                      value: job.category.isNotEmpty
                          ? job.category
                          : 'Sin categoría',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE1E4EC)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Indicaciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF202124),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Llega a tiempo al lugar indicado.\n'
                      '• Mantén comunicación con el contratante.\n'
                      '• Usa el botón de ayuda si ocurre algún problema.\n'
                      '• Al finalizar, confirma tu llegada o avance del turno.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF5F6368),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatLocation(Job job) {
    if (job.district.isNotEmpty && job.district != job.address) {
      return '${job.district} • ${job.address}';
    }

    if (job.address.isNotEmpty) return job.address;
    if (job.district.isNotEmpty) return job.district;

    return 'Ubicación no disponible';
  }

  static String _formatSchedule(Job job) {
    final start = _formatHour(job.scheduledStart);
    final end = _formatHour(job.scheduledEnd);

    if (start.isEmpty && end.isEmpty) {
      return 'Horario no disponible';
    }

    if (start.isNotEmpty && end.isNotEmpty) {
      return '$start - $end';
    }

    return start.isNotEmpty ? start : end;
  }

  static String _formatHour(String value) {
    if (value.isEmpty) return '';

    if (value.length >= 16) {
      return value.substring(11, 16);
    }

    return value;
  }
}

class _ActiveShiftRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ActiveShiftRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
          color: Color(0xFF5F6368),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5F6368),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF202124),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}