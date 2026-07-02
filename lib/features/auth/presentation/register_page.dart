import 'package:chambaya/features/auth/presentation/login_page.dart';
import 'package:chambaya/features/auth/presentation/login_view_model.dart';
import 'package:chambaya/features/auth/presentation/register_state.dart';
import 'package:chambaya/features/auth/presentation/register_view_model.dart';
import 'package:chambaya/core/di/dependency_injection.dart';
import 'package:chambaya/features/navigation/presentation/main_page.dart';
import 'package:chambaya/features/profile/presentation/skills_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _name     = TextEditingController();
  final TextEditingController _email    = TextEditingController();
  final TextEditingController _phone    = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String _role = 'CHAMBEADOR';
  List<String> _skills = [];

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<RegisterViewModel, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is RegisterSuccess) {
            if (_role == 'CHAMBEADOR') {
              // Ya quedó autenticado durante el registro (ver RegisterViewModel).
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cuenta creada. Ahora inicia sesión.'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => getIt<LoginViewModel>(),
                  child: LoginPage(),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  padding: EdgeInsets.zero,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Crea tu cuenta',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Regístrate para empezar a chambear.',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 28),

                const Text('Nombre completo', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    hintText:   'Juan Pérez',
                    prefixIcon: const Icon(Icons.person_outline),
                    border:     OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 16),

                const Text('Email', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextField(
                  controller:   _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText:   'nombre@ejemplo.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border:     OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 16),

                const Text('Teléfono', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextField(
                  controller:   _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText:   '77712345',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border:     OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 16),

                const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextField(
                  controller:  _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText:   '••••••••',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border:     OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 16),

                const Text('Quiero', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'CHAMBEADOR',
                      label: Text('Encontrar chambas'),
                      icon:  Icon(Icons.work_outline),
                    ),
                    ButtonSegment(
                      value: 'CONTRATANTE',
                      label: Text('Contratar'),
                      icon:  Icon(Icons.business_center_outlined),
                    ),
                  ],
                  selected: {_role},
                  onSelectionChanged: (selection) {
                    setState(() => _role = selection.first);
                  },
                ),

                const SizedBox(height: 28),

                BlocBuilder<RegisterViewModel, RegisterState>(
                  builder: (context, state) {
                    final isLoading = state is RegisterLoading;
                    return SizedBox(
                      width:  double.infinity,
                      height: 52,
                      child:  FilledButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_role == 'CHAMBEADOR') {
                                  final result = await Navigator.push<List<String>>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SkillsSelectionPage(initialSelected: _skills),
                                    ),
                                  );
                                  if (result == null) return;
                                  setState(() => _skills = result);
                                }
                                if (!context.mounted) return;
                                context.read<RegisterViewModel>().register(
                                  name:     _name.text.trim(),
                                  email:    _email.text.trim(),
                                  password: _password.text,
                                  phone:    _phone.text.trim(),
                                  role:     _role,
                                  skills:   _skills,
                                );
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3FD8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Crear cuenta', style: TextStyle(fontSize: 16)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta? '),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Inicia sesión',
                        style: TextStyle(
                          color:      Color(0xFF1A3FD8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
