import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _name  = TextEditingController(text: 'Diego');
  final _email = TextEditingController(text: 'diego@ejemplo.com');
  final _phone = TextEditingController(text: '+51 987 654 321');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Column(
        children: [
          // Top bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('Configuración', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // Avatar
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100, height: 100,
                              decoration: BoxDecoration(color: const Color(0xFFE8EDFB), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFDDDDDD), width: 2)),
                              child: const Center(child: Text('😊', style: TextStyle(fontSize: 48))),
                            ),
                            Positioned(
                              right: 0, bottom: 0,
                              child: Container(
                                width: 30, height: 30,
                                decoration: const BoxDecoration(color: Color(0xFF1A3FD8), shape: BoxShape.circle),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Cambiar foto', style: TextStyle(color: Color(0xFF1A3FD8), fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _SettingsField(label: 'Nombre completo', controller: _name,  icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  _SettingsField(label: 'Correo electrónico', controller: _email, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _SettingsField(label: 'Teléfono', controller: _phone, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Botón Guardar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width:  double.infinity,
                height: 54,
                child:  FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3FD8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Guardar cambios', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsField extends StatelessWidget {
  final String              label;
  final TextEditingController controller;
  final IconData            icon;
  final TextInputType       keyboardType;

  const _SettingsField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller:  controller,
          keyboardType: keyboardType,
          decoration:  InputDecoration(
            prefixIcon:   Icon(icon, color: Colors.grey),
            border:       OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A3FD8))),
            filled:       true,
            fillColor:    Colors.white,
          ),
        ),
      ],
    );
  }
}