import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Top Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                    const Text('ChambaYa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A3FD8))),
                    Stack(
                      children: [
                        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                        Positioned(right: 10, top: 10, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Avatar + Nombre + Rating
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(color: const Color(0xFFE8EDFB), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF1A3FD8), width: 2)),
                      child: const Center(child: Text('😊', style: TextStyle(fontSize: 44))),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        width: 24, height: 24,
                        decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Diego', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Color(0xFFFBBC04), size: 16),
                    SizedBox(width: 4),
                    Text('4.8 (124 reseñas)', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Habilidades
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Habilidades', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 32, height: 32,
                          decoration: const BoxDecoration(color: Color(0xFF1A3FD8), shape: BoxShape.circle),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      _SkillChip(label: 'Mesero', emoji: '🍽️', selected: true),
                      SizedBox(width: 10),
                      _SkillChip(label: 'Cajero', emoji: '🏧', selected: false),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Gestión
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gestión', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
                    child: Column(
                      children: [
                        _MenuItem(icon: Icons.work_outline, label: 'Mis Turnos', onTap: () {}),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _MenuItem(icon: Icons.credit_card_outlined, label: 'Billetera', onTap: () {}),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _MenuItem(icon: Icons.settings_outlined, label: 'Configuración', onTap: () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
                    child: _MenuItem(icon: Icons.exit_to_app, label: 'Cerrar sesión', labelColor: const Color(0xFFD93025), iconColor: const Color(0xFFD93025), onTap: () {}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool   selected;
  const _SkillChip({required this.label, required this.emoji, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1A3FD8) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? Colors.transparent : const Color(0xFFDDDDDD)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: selected ? Colors.white : const Color(0xFF0D0D0D))),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final Color        labelColor;
  final Color        iconColor;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.labelColor = const Color(0xFF0D0D0D), this.iconColor = const Color(0xFF1A3FD8)});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: labelColor)),
              ],
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}