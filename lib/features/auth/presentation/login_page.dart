import 'package:chambaya/features/auth/presentation/login_state.dart';
import 'package:chambaya/features/auth/presentation/login_view_model.dart';
import 'package:chambaya/features/navigation/presentation/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _email    = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Logo
                const Text(
                  'ChambaYa',
                  style: TextStyle(
                    fontSize:   26,
                    fontWeight: FontWeight.w800,
                    color:      Color(0xFF1A3FD8),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Bienvenido de nuevo',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Inicia sesión para encontrar tu próximo chambe.',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 32),

                // Email
                const Text('Email', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText:      'nombre@ejemplo.com',
                    prefixIcon:    const Icon(Icons.email_outlined),
                    border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    hintStyle:     const TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 16),

                // Contraseña
                const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextField(
                  controller:  _password,
                  obscureText: true,
                  decoration:  InputDecoration(
                    hintText:   '••••••••',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border:     OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 28),

                // Botón
                BlocBuilder<LoginViewModel, LoginState>(
                  builder: (context, state) {
                    final isLoading = state is LoginLoading;
                    return SizedBox(
                      width:  double.infinity,
                      height: 52,
                      child:  FilledButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<LoginViewModel>().login(
                                  email:    _email.text.trim(),
                                  password: _password.text,
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
                            : const Text('Iniciar sesión',
                                style: TextStyle(fontSize: 16)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Ir a registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? '),
                    GestureDetector(
                      onTap: () {
                        // navegar a register
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          color:      Color(0xFF1A3FD8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}