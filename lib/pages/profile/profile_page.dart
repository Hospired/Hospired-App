import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backend-api/api_service.dart';
import '../../backend-api/dtos.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUserRes? userData;
  PatientRes? patientData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final session = ApiService.checkAndGetUserSession();
    if (session == null) return;

    final appUser = await ApiService.getAppUser(session.id);
    final patient = await ApiService.getPatient(session.id);

    setState(() {
      userData = appUser;
      patientData = patient;
      isLoading = false;
    });
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileView(),
    );
  }

  Widget _buildProfileView() {
    if (userData == null) {
      return const Center(child: Text("No se encontraron datos del usuario."));
    }

    final Map<String, String> profileMap = {
      "Nombre": "${userData!.firstName} ${userData!.secondName ?? ''}".trim(),
      "Apellidos":
          "${userData!.firstLastName} ${userData!.secondLastName ?? ''}".trim(),
      "Cédula": patientData?.nationalId ?? "Sin registrar",
      "Teléfono": patientData?.phoneNumber ?? "Sin registrar",
      "Ocupación": patientData?.occupation ?? "Sin registrar",
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal[200],
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ...profileMap.entries.map(
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
    );
  }

  Icon _getIconForKey(String key) {
    switch (key) {
      case "Nombre":
        return const Icon(Icons.badge, color: Colors.teal);
      case "Apellidos":
        return const Icon(Icons.person, color: Colors.teal);
      case "Cédula":
        return const Icon(Icons.credit_card, color: Colors.teal);
      case "Teléfono":
        return const Icon(Icons.phone, color: Colors.teal);
      case "Ocupación":
        return const Icon(Icons.work, color: Colors.teal);
      default:
        return const Icon(Icons.info, color: Colors.teal);
    }
  }
}
