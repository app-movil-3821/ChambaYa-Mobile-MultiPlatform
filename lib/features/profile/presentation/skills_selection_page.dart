import 'package:flutter/material.dart';

class _SkillOption {
  final String label;
  final IconData icon;
  const _SkillOption(this.label, this.icon);
}

const List<_SkillOption> _skillOptions = [
  _SkillOption('Mesero', Icons.restaurant_outlined),
  _SkillOption('Cajero', Icons.point_of_sale_outlined),
  _SkillOption('Cocina', Icons.soup_kitchen_outlined),
  _SkillOption('Reparto', Icons.moped_outlined),
  _SkillOption('Almacén', Icons.warehouse_outlined),
  _SkillOption('Limpieza', Icons.cleaning_services_outlined),
];

/// Selector de habilidades. Devuelve la lista elegida vía [Navigator.pop]
/// cuando el usuario presiona "Continuar"; no persiste nada por sí misma.
class SkillsSelectionPage extends StatefulWidget {
  final List<String> initialSelected;

  const SkillsSelectionPage({super.key, this.initialSelected = const []});

  @override
  State<SkillsSelectionPage> createState() => _SkillsSelectionPageState();
}

class _SkillsSelectionPageState extends State<SkillsSelectionPage> {
  late final Set<String> _selected = {...widget.initialSelected};

  void _toggle(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Back + progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                  ),
                  Row(
                    children: List.generate(3, (i) => Container(
                      margin: const EdgeInsets.only(left: 6),
                      width:  10,
                      height: 6,
                      decoration: BoxDecoration(
                        color:        i < 2 ? const Color(0xFF1A3FD8) : const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                '¿En qué eres bueno?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona tus habilidades para encontrar los mejores turnos.',
                style: TextStyle(color: Colors.grey, height: 1.4),
              ),

              const SizedBox(height: 28),

              Expanded(
                child: GridView.count(
                  crossAxisCount:  2,
                  mainAxisSpacing:  16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.15,
                  children: _skillOptions.map((option) {
                    final isSelected = _selected.contains(option.label);
                    return _SkillCard(
                      label:      option.label,
                      icon:       option.icon,
                      isSelected: isSelected,
                      onTap:      () => _toggle(option.label),
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: SizedBox(
                  width:  double.infinity,
                  height: 54,
                  child:  FilledButton(
                    onPressed: () {
                      if (_selected.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selecciona al menos una habilidad')),
                        );
                        return;
                      }
                      Navigator.pop(context, _selected.toList());
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3FD8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Continuar', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final String       label;
  final IconData     icon;
  final bool         isSelected;
  final VoidCallback onTap;

  const _SkillCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:        isSelected ? const Color(0xFF1A3FD8) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE2E2EA),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width:  44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFF0F1FB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size:  22,
                color: isSelected ? Colors.white : const Color(0xFF1A3FD8),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize:   15,
                fontWeight: FontWeight.w600,
                color:      isSelected ? Colors.white : const Color(0xFF0D0D0D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
