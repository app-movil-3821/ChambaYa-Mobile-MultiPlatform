import 'package:chambaya/features/home/domain/job.dart';
import 'package:chambaya/features/home/presentation/home_state.dart';
import 'package:chambaya/features/home/presentation/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeViewModel>().loadPublishedJobs();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      appBar: AppBar(
        title: const Text(
          'Trabajos disponibles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202124),
        elevation: 0,
      ),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HomeFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }

          if (state is HomeSuccess) {
            if (state.jobs.isEmpty) {
              return const Center(
                child: Text('No hay trabajos publicados por ahora.'),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<HomeViewModel>().loadPublishedJobs(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.jobs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final job = state.jobs[index];

                  return JobCard(job: job);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE1E4EC)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF202124),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5F6368),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xFF5F6368),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.district.isNotEmpty && job.district != job.address
                      ? '${job.district} • ${job.address}'
                      : job.address,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.schedule_outlined,
                  size: 18,
                  color: Color(0xFF5F6368),
                ),
                const SizedBox(width: 4),
                Text(
                  '${_formatHour(job.scheduledStart)} - ${_formatHour(job.scheduledEnd)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5F6368),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(job.category),
                  backgroundColor: const Color(0xFFEAF0FF),
                  labelStyle: const TextStyle(
                    color: Color(0xFF1A3FD8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'S/ ${job.paymentAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3FD8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatHour(String value) {
    if (value.length >= 16) {
      return value.substring(11, 16);
    }

    return value;
  }
}