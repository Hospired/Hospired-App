import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend-api/init_supabase.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'notifications_service.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar supabase, notificaciones y timezone
  await initSupabase();
  await initNotifications();

  final prefs = await SharedPreferences.getInstance();
  final isLogged = prefs.getBool('isLogged') ?? false;

  runApp(MyApp(initialRoute: isLogged ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospired',
      theme: AppTheme.theme,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
