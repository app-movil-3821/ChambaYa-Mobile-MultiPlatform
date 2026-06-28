import 'package:chambaya/features/shifts/domain/enrollment.dart';
import 'package:chambaya/features/shifts/domain/job.dart';
import 'package:chambaya/features/shifts/presentation/shifts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chambaya/features/shifts/presentation/create_job_page.dart';

const _blue = Color(0xFF1A3FD8);

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
  return BlocBuilder<ShiftsViewModel, ShiftsState>(
    builder: (context, state) {
      final isContractor = state is ContractorShiftsLoaded;

      return Scaffold(
        backgroundColor: const Color(0xFFF8F7FD),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isContractor ? 'Mis Chambas' : 'Mis Turnos',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
              ),
              Text(
                isContractor ? 'Trabajos que has publicado' : 'Historial de tus trabajos',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: isContractor
            ? FloatingActionButton.extended(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ShiftsViewModel>(),
                        child: const CreateJobPage(),
                      ),
                    ),
                  );
                  if (context.mounted) {
                    context.read<ShiftsViewModel>().loadShifts();
                  }
                },
                backgroundColor: _blue,
                icon: const Icon(Icons.work_outline),
                label: const Text('Publicar Chamba', style: TextStyle(fontWeight: FontWeight.bold)),
              )
            : null,
        body: _buildBody(context, state),
      );
    },
  );
}

  Widget _buildBody(BuildContext context, ShiftsState state) {
    if (state is ShiftsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ShiftsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
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
      return _ContractorView(state: state);
    }

    return const SizedBox.shrink();
  }
}

// ── CHAMBEADOR ────────────────────────────────────────────────────

class _WorkerView extends StatelessWidget {
  final List<Enrollment> enrollments;
  const _WorkerView({required this.enrollments});

  @override
  Widget build(BuildContext context) {
    if (enrollments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aún no tienes postulaciones', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: enrollments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _EnrollmentCard(enrollment: enrollments[i]),
    );
  }
}

class _EnrollmentCard extends StatelessWidget {
  final Enrollment enrollment;
  const _EnrollmentCard({required this.enrollment});

  Color _color(String s) {
    switch (s.toUpperCase()) {
      case 'PENDING':   return Colors.orange;
      case 'ACCEPTED':  return Colors.green;
      case 'REJECTED':  return Colors.red;
      case 'CANCELLED': return Colors.grey;
      default:          return _blue;
    }
  }

  String _label(String s) {
    switch (s.toUpperCase()) {
      case 'PENDING':   return 'Pendiente';
      case 'ACCEPTED':  return 'Aceptado';
      case 'REJECTED':  return 'Rechazado';
      case 'CANCELLED': return 'Cancelado';
      default:          return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = enrollment.job;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
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
                    job?.title ?? enrollment.jobId,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                _StatusBadge(label: _label(enrollment.status), color: _color(enrollment.status)),
              ],
            ),
            if (job != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.storefront_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.category, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  job.scheduledStart.length >= 10 ? job.scheduledStart.substring(0, 10) : job.scheduledStart,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ]),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pago recibido', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text(
                    'S/ ${job.paymentAmount}',
                    style: const TextStyle(color: _blue, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ],
            if (enrollment.status.toUpperCase() == 'PENDING') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.read<ShiftsViewModel>().cancelEnrollment(enrollment.id),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
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

// ── CONTRATANTE ───────────────────────────────────────────────────

class _ContractorView extends StatelessWidget {
  final ContractorShiftsLoaded state;
  const _ContractorView({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.jobs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aún no has publicado trabajos', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: state.jobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _JobCard(
        job:         state.jobs[i],
        enrollments: state.enrollmentsByJob[state.jobs[i].id],
        isExpanded:  state.expandedJobs.contains(state.jobs[i].id),
        isLoading:   state.loadingEnrollments.contains(state.jobs[i].id),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job                job;
  final List<Enrollment>?  enrollments;
  final bool               isExpanded;
  final bool               isLoading;

  const _JobCard({
    required this.job,
    required this.isExpanded,
    required this.isLoading,
    this.enrollments,
  });

  Color _color(String s) {
    switch (s.toUpperCase()) {
      case 'DRAFT':       return Colors.grey;
      case 'PUBLISHED':   return _blue;
      case 'IN_PROGRESS': return Colors.orange;
      case 'COMPLETED':   return Colors.green;
      case 'CLOSED':      return Colors.purple;
      case 'CANCELLED':   return Colors.red;
      default:            return Colors.grey;
    }
  }

  String _label(String s) {
    switch (s.toUpperCase()) {
      case 'DRAFT':       return 'Borrador';
      case 'PUBLISHED':   return 'Publicado';
      case 'IN_PROGRESS': return 'En progreso';
      case 'COMPLETED':   return 'Completado';
      case 'CLOSED':      return 'Cerrado';
      case 'CANCELLED':   return 'Cancelado';
      default:            return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm     = context.read<ShiftsViewModel>();
    final status = job.status.toUpperCase();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                _StatusBadge(label: _label(job.status), color: _color(job.status)),
              ],
            ),
            const SizedBox(height: 6),

            // Dirección
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${job.address}, ${job.district}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
            const SizedBox(height: 8),

            // Precio
            Text(
              'S/ ${job.paymentAmount}',
              style: const TextStyle(color: _blue, fontWeight: FontWeight.bold, fontSize: 15),
            ),

            const SizedBox(height: 12),

            // Ver postulantes (solo PUBLISHED o IN_PROGRESS)
            if (status == 'PUBLISHED' || status == 'IN_PROGRESS') ...[
              InkWell(
                onTap: () => vm.toggleEnrollments(job.id),
                child: Row(
                  children: [
                    Text(
                      isExpanded ? 'Ocultar postulantes' : 'Ver postulantes',
                      style: const TextStyle(color: _blue, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: _blue,
                    ),
                  ],
                ),
              ),

              if (isExpanded) ...[
                const SizedBox(height: 8),
                if (isLoading)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ))
                else if (enrollments == null || enrollments!.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Sin postulantes aún.', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...enrollments!.map((e) => _EnrollmentRow(
                    enrollment: e,
                    jobId:      job.id,
                  )),
                const SizedBox(height: 8),
              ],
            ],

            // Acciones
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (status == 'DRAFT')
                  _ActionButton(label: 'Publicar', color: _blue, onTap: () => vm.publishJob(job.id)),

                if (status == 'PUBLISHED')
                  _ActionButton(label: 'Iniciar', color: _blue, onTap: () => vm.startJob(job.id)),

                if (status == 'IN_PROGRESS')
                  _ActionButton(label: 'Completar', color: Colors.green, onTap: () => vm.completeJob(job.id)),

                if (status == 'COMPLETED')
                  _ActionButton(label: 'Cerrar', color: Colors.purple, onTap: () => vm.closeJob(job.id)),

                if (status == 'CANCELLED')
                  _ActionButton(label: 'Reabrir', color: Colors.orange, onTap: () => vm.reopenJob(job.id)),

                if (!['COMPLETED', 'CLOSED', 'CANCELLED'].contains(status))
                  _ActionButton(
                    label:    'Cancelar',
                    color:    Colors.red,
                    outlined: true,
                    onTap:    () => vm.cancelJob(job.id),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EnrollmentRow extends StatelessWidget {
  final Enrollment enrollment;
  final String     jobId;
  const _EnrollmentRow({required this.enrollment, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final vm     = context.read<ShiftsViewModel>();
    final status = enrollment.status.toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: _blue.withOpacity(0.1),
            child: Text(
              (enrollment.workerName.isNotEmpty ? enrollment.workerName : enrollment.workerId)[0].toUpperCase(),
              style: const TextStyle(color: _blue, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              enrollment.workerName.isNotEmpty ? enrollment.workerName : enrollment.workerId,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (status == 'PENDING') ...[
            TextButton(
              onPressed: () => vm.acceptEnrollment(enrollment.id, jobId),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(70, 32),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Aceptar', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 6),
            TextButton(
              onPressed: () => vm.rejectEnrollment(enrollment.id, jobId),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                minimumSize: const Size(70, 32),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
              child: const Text('Rechazar', style: TextStyle(fontSize: 12)),
            ),
          ] else
            _StatusBadge(
              label: status == 'ACCEPTED' ? 'Aceptado' : status == 'REJECTED' ? 'Rechazado' : status,
              color: status == 'ACCEPTED' ? Colors.green : Colors.red,
            ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color  color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String   label;
  final Color    color;
  final bool     outlined;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      );
    }
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}