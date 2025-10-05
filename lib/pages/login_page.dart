import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend-api/api_service.dart';
import '../theme.dart';

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
      setState(() => error = "Cédula o contraseña incorrecta");
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
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailController,
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
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              loading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          constraints: BoxConstraints(
                            minWidth: 48,
                            maxWidth: 48,
                            minHeight: 48,
                            maxHeight: 48,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () => _login(context),
                      child: const Text("Ingresar"),
                    ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(error, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
