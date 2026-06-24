import 'package:chambaya/features/shifts/domain/enrollment.dart';
import 'package:chambaya/features/shifts/domain/job.dart';
import 'package:chambaya/features/shifts/presentation/shifts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShiftsPage extends StatefulWidget {
  const ShiftsPage({super.key});

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShiftsViewModel>().loadShifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Turnos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<ShiftsViewModel, ShiftsState>(
        builder: (context, state) {
          if (state is ShiftsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ShiftsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ShiftsViewModel>().loadShifts(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is WorkerShiftsLoaded) {
            return _WorkerView(enrollments: state.enrollments);
          }

          if (state is ContractorShiftsLoaded) {
            return _ContractorView(jobs: state.jobs);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Vista Chambeador ──────────────────────────────────────────────

class _WorkerView extends StatelessWidget {
  final List<Enrollment> enrollments;
  const _WorkerView({required this.enrollments});

  @override
  Widget build(BuildContext context) {
    if (enrollments.isEmpty) {
      return const Center(
        child: Text('Aún no tienes postulaciones.', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: enrollments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final e = enrollments[index];
        return _EnrollmentCard(enrollment: e);
      },
    );
  }
}

class _EnrollmentCard extends StatelessWidget {
  final Enrollment enrollment;
  const _EnrollmentCard({required this.enrollment});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':     return Colors.orange;
      case 'ACCEPTED':    return Colors.green;
      case 'REJECTED':    return Colors.red;
      case 'CANCELLED':   return Colors.grey;
      default:            return Colors.blue;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':     return 'Pendiente';
      case 'ACCEPTED':    return 'Aceptado';
      case 'REJECTED':    return 'Rechazado';
      case 'CANCELLED':   return 'Cancelado';
      default:            return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ShiftsViewModel>();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    enrollment.job?.title ?? enrollment.jobId,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(enrollment.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(enrollment.status),
                    style: TextStyle(
                      color: _statusColor(enrollment.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (enrollment.job != null) ...[
              const SizedBox(height: 8),
              Text(enrollment.job!.district, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                'S/ ${enrollment.job!.paymentAmount}',
                style: const TextStyle(color: Color(0xFF0B57D0), fontWeight: FontWeight.bold),
              ),
            ],
            if (enrollment.status.toUpperCase() == 'PENDING') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => vm.cancelEnrollment(enrollment.id),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Cancelar postulación'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Vista Contratante ─────────────────────────────────────────────

class _ContractorView extends StatelessWidget {
  final List<Job> jobs;
  const _ContractorView({required this.jobs});

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text('Aún no has publicado trabajos.', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _JobCard(job: jobs[index]),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;
  const _JobCard({required this.job});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':       return Colors.grey;
      case 'PUBLISHED':   return Colors.blue;
      case 'IN_PROGRESS': return Colors.orange;
      case 'COMPLETED':   return Colors.green;
      case 'CLOSED':      return Colors.purple;
      case 'CANCELLED':   return Colors.red;
      default:            return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':       return 'Borrador';
      case 'PUBLISHED':   return 'Publicado';
      case 'IN_PROGRESS': return 'En progreso';
      case 'COMPLETED':   return 'Completado';
      case 'CLOSED':      return 'Cerrado';
      case 'CANCELLED':   return 'Cancelado';
      default:            return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ShiftsViewModel>();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(job.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(job.status),
                    style: TextStyle(
                      color: _statusColor(job.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(job.district, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              'S/ ${job.paymentAmount}',
              style: const TextStyle(color: Color(0xFF0B57D0), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Acciones según estado
            Wrap(
              spacing: 8,
              children: [
                if (job.status.toUpperCase() == 'DRAFT')
                  ElevatedButton(
                    onPressed: () => vm.publishJob(job.id),
                    child: const Text('Publicar'),
                  ),
                if (job.status.toUpperCase() == 'PUBLISHED') ...[
                  ElevatedButton(
                    onPressed: () => vm.startJob(job.id),
                    child: const Text('Iniciar'),
                  ),
                  OutlinedButton(
                    onPressed: () => vm.loadEnrollmentsForJob(job.id),
                    child: const Text('Ver postulantes'),
                  ),
                ],
                if (job.status.toUpperCase() == 'IN_PROGRESS')
                  ElevatedButton(
                    onPressed: () => vm.completeJob(job.id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Completar'),
                  ),
                if (!['COMPLETED', 'CLOSED', 'CANCELLED'].contains(job.status.toUpperCase()))
                  OutlinedButton(
                    onPressed: () => vm.cancelJob(job.id),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Cancelar'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}