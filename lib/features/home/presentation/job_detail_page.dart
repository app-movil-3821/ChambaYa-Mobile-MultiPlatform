import 'package:chambaya/features/home/domain/job.dart';
import 'package:chambaya/features/home/presentation/apply_page.dart';
import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  final Job job;

  const JobDetailPage({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      appBar: AppBar(
        title: const Text(
          'Detalle del trabajo',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ApplyPage(job: job),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2146E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Postular',
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
        child: Card(
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
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 12),

                _InfoChip(text: job.category),

                const SizedBox(height: 20),

                const Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  job.description.isNotEmpty
                      ? job.description
                      : 'Sin descripción disponible.',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Color(0xFF5F6368),
                  ),
                ),

                const SizedBox(height: 24),

                _DetailRow(
                  icon: Icons.location_on_outlined,
                  title: 'Ubicación',
                  value: _formatLocation(job),
                ),

                const SizedBox(height: 16),

                _DetailRow(
                  icon: Icons.schedule_outlined,
                  title: 'Horario',
                  value: _formatSchedule(job),
                ),

                const SizedBox(height: 16),

                _DetailRow(
                  icon: Icons.payments_outlined,
                  title: 'Pago',
                  value: 'S/ ${job.paymentAmount.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 16),

                _DetailRow(
                  icon: Icons.info_outline,
                  title: 'Estado',
                  value: job.status.isNotEmpty ? job.status : 'Disponible',
                ),

                const SizedBox(height: 24),

                const Text(
                  'Habilidades requeridas',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 10),

                if (job.requiredSkills.isEmpty)
                  const Text(
                    'No se especificaron habilidades.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5F6368),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.requiredSkills
                        .map((skill) => _InfoChip(text: skill))
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatLocation(Job job) {
    if (job.district.isNotEmpty && job.district != job.address) {
      return '${job.district} • ${job.address}';
    }

    if (job.address.isNotEmpty) {
      return job.address;
    }

    if (job.district.isNotEmpty) {
      return job.district;
    }

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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
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
          color: const Color(0xFF5F6368),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5F6368),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
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

class _InfoChip extends StatelessWidget {
  final String text;

  const _InfoChip({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: const Color(0xFFEAF0FF),
      labelStyle: const TextStyle(
        color: Color(0xFF1A3FD8),
        fontWeight: FontWeight.w600,
      ),
      side: const BorderSide(color: Color(0xFFC9D6FF)),
    );
  }
}