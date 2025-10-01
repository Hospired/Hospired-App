import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Datos de ejemplo; en producción, los podrías cargar desde SQLite
  final Map<String, String> userData = const {
    "Nombre": "José",
    "Apellidos": "López Pérez",
    "Cédula": "1234567890",
    "Tipo de sangre": "O+",
    "Dirección": "Calle 123, Managua, Nicaragua",
    "Usuario": "jose123",
  };

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogged', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto de perfil circular
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal[200],
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Tarjetas con información
            ...userData.entries.map(
              (entry) => Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: _getIconForKey(entry.key),
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(entry.value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para asignar íconos según la información
  Icon _getIconForKey(String key) {
    switch (key) {
      case "Nombre":
        return const Icon(Icons.badge, color: Colors.teal);
      case "Apellidos":
        return const Icon(Icons.person, color: Colors.teal);
      case "Cédula":
        return const Icon(Icons.credit_card, color: Colors.teal);
      case "Tipo de sangre":
        return const Icon(Icons.bloodtype, color: Colors.red);
      case "Dirección":
        return const Icon(Icons.location_on, color: Colors.teal);
      case "Usuario":
        return const Icon(Icons.account_circle, color: Colors.teal);
      default:
        return const Icon(Icons.info, color: Colors.teal);
    }
  }
}
