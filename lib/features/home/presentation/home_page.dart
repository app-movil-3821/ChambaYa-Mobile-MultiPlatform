import 'package:chambaya/features/home/domain/job.dart';
import 'package:chambaya/features/home/presentation/job_detail_page.dart';
import 'package:chambaya/features/home/presentation/home_state.dart';
import 'package:chambaya/features/home/presentation/home_view_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 15),
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
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  JobsMapCard(jobs: state.jobs),

                  const SizedBox(height: 12),

                  ...state.jobs.map(
                    (job) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: JobCard(
                        job: job,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailPage(job: job),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
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
  final VoidCallback onTap;

  const JobCard({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
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
                style: const TextStyle(fontSize: 14, color: Color(0xFF5F6368)),
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
                    _formatSchedule(job),
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
      ),
    );
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

class JobsMapCard extends StatefulWidget {
  final List<Job> jobs;

  const JobsMapCard({super.key, required this.jobs});

  @override
  State<JobsMapCard> createState() => _JobsMapCardState();
}

class _JobsMapCardState extends State<JobsMapCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final jobsWithLocation = widget.jobs
        .where((job) => job.latitude != 0 && job.longitude != 0)
        .toList();

    final LatLng center = jobsWithLocation.isNotEmpty
        ? LatLng(
            jobsWithLocation.first.latitude,
            jobsWithLocation.first.longitude,
          )
        : const LatLng(-12.0464, -77.0428);

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE1E4EC)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    color: Color(0xFF2146E8),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ubicación de trabajos',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF202124),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jobsWithLocation.isEmpty
                            ? 'No hay ubicaciones disponibles'
                            : '${jobsWithLocation.length} trabajos cerca de la zona',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5F6368),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                  ),
                  label: Text(_expanded ? 'Contraer' : 'Expandir'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2146E8),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: _expanded ? 320 : 170,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFC9D6FF)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: jobsWithLocation.isEmpty
                    ? Container(
                        color: const Color(0xFFF2F5FF),
                        child: const Center(
                          child: Text(
                            'No hay trabajos con coordenadas.',
                            style: TextStyle(
                              color: Color(0xFF5F6368),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          FlutterMap(
                            options: MapOptions(
                              initialCenter: center,
                              initialZoom: _expanded ? 12.8 : 11.8,
                              interactionOptions: const InteractionOptions(
                                flags:
                                    InteractiveFlag.all &
                                    ~InteractiveFlag.rotate,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.chambaya',
                              ),
                              MarkerLayer(
                                markers: jobsWithLocation.map((job) {
                                  return Marker(
                                    point: LatLng(job.latitude, job.longitude),
                                    width: 48,
                                    height: 48,
                                    child: Tooltip(
                                      message: job.title,
                                      child: const _JobMapMarker(),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE1E4EC),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    size: 18,
                                    color: Color(0xFF2146E8),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _expanded
                                          ? 'Puedes mover el mapa y tocar los marcadores.'
                                          : 'Expande el mapa para ver mejor las ubicaciones.',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF5F6368),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
}

class _JobMapMarker extends StatelessWidget {
  const _JobMapMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: const Icon(Icons.location_on, color: Color(0xFF2146E8), size: 34),
    );
  }
}
