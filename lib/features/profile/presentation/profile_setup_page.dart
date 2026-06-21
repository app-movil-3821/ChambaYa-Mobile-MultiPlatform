import 'package:flutter/material.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _bio = TextEditingController();
  int _charCount = 0;
  static const int _maxChars = 250;

  @override
  void initState() {
    super.initState();
    _bio.addListener(() => setState(() => _charCount = _bio.text.length));
  }

  @override
  void dispose() {
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Progress dots
              Row(
                children: List.generate(3, (i) => Container(
                  margin: const EdgeInsets.only(right: 6),
                  width:  i == 0 ? 28 : 10,
                  height: 6,
                  decoration: BoxDecoration(
                    color:        i == 0 ? const Color(0xFF1A3FD8) : const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),

              const SizedBox(height: 32),

              const Text('Completa tu perfil', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Tu foto y biografía ayudan a generar confianza con otros usuarios.', style: TextStyle(color: Colors.grey, height: 1.5)),

              const SizedBox(height: 36),

              // Avatar
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(color: const Color(0xFFF0F0F5), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFDDDDDD), width: 2)),
                          child: const Icon(Icons.person, color: Colors.grey, size: 50),
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
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Subir foto', style: TextStyle(color: Color(0xFF1A3FD8), fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text('Cuéntanos sobre ti', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              TextField(
                controller:  _bio,
                maxLines:    5,
                maxLength:   _maxChars,
                decoration:  InputDecoration(
                  counterText:  '$_charCount / $_maxChars',
                  border:       OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A3FD8))),
                  filled:       true,
                  fillColor:    const Color(0xFFF7F8FC),
                ),
              ),

              const SizedBox(height: 6),
              const Text('Este texto será visible en tu perfil público.', style: TextStyle(fontSize: 12, color: Colors.grey)),

              const SizedBox(height: 16),

              // Tip card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFEEF1FB), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Color(0xFF1A3FD8), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Tip de experto', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A3FD8))),
                          SizedBox(height: 4),
                          Text('Los perfiles con una biografía detallada tienen un 40% más de probabilidades de conseguir un empleo rápido.', style: TextStyle(fontSize: 13, color: Color(0xFF4B6FD8), height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Botón Siguiente
              SizedBox(
                width:  double.infinity,
                height: 54,
                child:  FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3FD8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Siguiente', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}