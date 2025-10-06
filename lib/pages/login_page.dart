import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend-api/api_service.dart';
import '../colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String error = "";
  bool loading = false;

  void _login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    setState(() => loading = true);

    try {
      await ApiService.signInUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // TODO: the following will be removed, session will be handled by supabase client
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogged', true);

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => error = "Correo electrónico o contraseña incorrecta");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('H O S P I R E D')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailController,
                onChanged: (value) => setState(() => error = ""),
                readOnly: loading,
                decoration: const InputDecoration(
                  labelText: "Correo Electrónico",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                readOnly: loading,
                onChanged: (value) => setState(() => error = ""),
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => _login(context),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : () => _login(context),
                child: const Text("Ingresar"),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: HospiredColors.danger),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
