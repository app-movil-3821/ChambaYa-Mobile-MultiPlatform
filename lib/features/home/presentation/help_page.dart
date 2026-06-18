import 'package:chambaya/features/home/domain/job.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  final Job job;

  const HelpPage({
    super.key,
    required this.job,
  });

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _problemTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _problemTypeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _sendHelpRequest() {
    final problemType = _problemTypeController.text.trim();
    final description = _descriptionController.text.trim();

    if (problemType.isEmpty) {
      setState(() {
        _errorMessage = 'Ingresa el tipo de problema.';
        _successMessage = null;
      });
      return;
    }

    if (description.isEmpty) {
      setState(() {
        _errorMessage = 'Describe brevemente el problema.';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _successMessage = 'Solicitud enviada correctamente.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Solicitud de ayuda enviada correctamente.'),
      ),
    );
  }

  void _clearMessages() {
    if (_errorMessage != null || _successMessage != null) {
      setState(() {
        _errorMessage = null;
        _successMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      appBar: AppBar(
        title: const Text(
          'Pedir ayuda',
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
              onPressed: _sendHelpRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2146E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Enviar mensaje',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpHeaderCard(jobTitle: widget.job.title),

            const SizedBox(height: 24),

            const Text(
              'Tipo de problema',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202124),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _problemTypeController,
              onChanged: (_) => _clearMessages(),
              decoration: InputDecoration(
                hintText: 'Ejemplo: retraso, ubicación, emergencia',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.report_problem_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE1E4EC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE1E4EC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF2146E8)),
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202124),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _descriptionController,
              onChanged: (_) => _clearMessages(),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe brevemente lo que ocurrió',
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE1E4EC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE1E4EC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF2146E8)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Color(0xFFD93025),
                  fontWeight: FontWeight.w600,
                ),
              ),

            if (_successMessage != null)
              Text(
                _successMessage!,
                style: const TextStyle(
                  color: Color(0xFF2E9E6B),
                  fontWeight: FontWeight.w600,
                ),
              ),

            const SizedBox(height: 24),

            const Text(
              'Adjuntar evidencia',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202124),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE1E4EC)),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 44,
                    color: Color(0xFF5F6368),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adjuntar imagen o evidencia',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF202124),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Por ahora esta opción es visual.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                ],
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
                'Tu solicitud será registrada para que el equipo pueda revisar el problema. Más adelante esta acción puede conectarse al módulo de mensajes o soporte.',
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
}

class _HelpHeaderCard extends StatelessWidget {
  final String jobTitle;

  const _HelpHeaderCard({
    required this.jobTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Icons.support_agent_outlined,
            size: 64,
            color: Color(0xFF2146E8),
          ),
          const SizedBox(height: 12),
          const Text(
            '¿Necesitas ayuda?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            jobTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF5F6368),
            ),
          ),
        ],
      ),
    );
  }
}