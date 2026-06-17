import 'package:chambaya/features/home/domain/job.dart';
import 'package:flutter/material.dart';

class ApplyPage extends StatelessWidget {
  final Job job;

  const ApplyPage({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      appBar: AppBar(
        title: const Text(
          'Confirmar postulación',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202124),
        elevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Postulación enviada correctamente.'),
                  ),
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2146E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Confirmar postulación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.assignment_turned_in_outlined,
              size: 72,
              color: Color(0xFF2146E8),
            ),

            const SizedBox(height: 16),

            const Text(
              '¿Deseas postular a este trabajo?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: Color(0xFF202124),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Revisa los datos antes de confirmar tu postulación.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF5F6368),
              ),
            ),

            const SizedBox(height: 24),

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
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF202124),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      job.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Color(0xFF5F6368),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _ApplyInfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Ubicación',
                      value: _formatLocation(job),
                    ),

                    const SizedBox(height: 14),

                    _ApplyInfoRow(
                      icon: Icons.schedule_outlined,
                      title: 'Horario',
                      value: _formatSchedule(job),
                    ),

                    const SizedBox(height: 14),

                    _ApplyInfoRow(
                      icon: Icons.payments_outlined,
                      title: 'Pago',
                      value: 'S/ ${job.paymentAmount.toStringAsFixed(2)}',
                    ),

                    const SizedBox(height: 14),

                    _ApplyInfoRow(
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

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFC9D6FF)),
              ),
              child: const Text(
                'Al confirmar, el contratante podrá revisar tu postulación. Más adelante conectaremos esta acción con el backend.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1A3FD8),
                  height: 1.4,
                  fontWeight: FontWeight.w500,
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

class _ApplyInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ApplyInfoRow({
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