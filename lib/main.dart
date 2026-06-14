import 'package:chambaya/core/di/dependency_injection.dart';
import 'package:chambaya/features/auth/presentation/login_page.dart';
import 'package:chambaya/features/auth/presentation/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setup();
  runApp(const ChambaYaApp());
}

class ChambaYaApp extends StatelessWidget {
  const ChambaYaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChambaYa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A3FD8)),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => getIt<LoginViewModel>(),
        child: LoginPage(),
      ),
    );
  }
}