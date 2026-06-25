import 'package:chambaya/core/di/dependency_injection.dart';
import 'package:chambaya/features/home/presentation/home_page.dart';
import 'package:chambaya/features/home/presentation/home_view_model.dart';
import 'package:chambaya/features/profile/presentation/profile_page.dart';
import 'package:chambaya/features/profile/presentation/profile_view_model.dart';
import 'package:chambaya/features/messages/presentation/messages_page.dart';
import 'package:chambaya/features/messages/presentation/messages_view_model.dart';
import 'package:chambaya/core/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    // Cargar userId al iniciar
    getIt<TokenStorage>().getUserId().then((id) {
      setState(() => _userId = id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          BlocProvider(
            create: (_) => getIt<HomeViewModel>(),
            child: const HomePage(),
          ),
          const Center(child: Text('Shifts')),
          BlocProvider(
            create: (_) {
            final vm = getIt<MessagesViewModel>();
            getIt<TokenStorage>().getUserId().then((id) {
            if (id != null) vm.loadConversations(userId: id);
            });
              return vm;
            },
            child: const MessagesPage(),
            ),

          if (_userId != null)
            BlocProvider(
              create: (_) => getIt<ProfileViewModel>()
                ..loadProfile(userId: _userId!),
              child: const ProfilePage(),
            )
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.work_outline), label: 'Shifts'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}