import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'DatabaseHelper.dart';
import 'package:intl/intl.dart';

// ===================== MAIN =====================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

// ===================== THEME =====================

class AppTheme {
  static const Color primaryColor = Color.fromRGBO(35, 169, 214, 1);

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      centerTitle: true,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    ),
  );
}



// ===================== HOME PAGE =====================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    PerfilPage(),
    CitasPage(),
    TratamientoPage(),
    PatologiasPage(),
    ChatBotPage(),
    MapaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Citas'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Tratamiento'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Patologías'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        ],
      ),
    );
  }
}

// ===================== PÁGINAS =====================

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

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

// CITAS


class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> citas = [];

  @override
  void initState() {
    super.initState();
    _loadCitas();
  }

  Future<void> _loadCitas() async {
    final data = await dbHelper.getCitas();

  for (var cita in data) {
    print("📅 Fecha en BD: ${cita['fecha']}");
  }

  setState(() {
    citas = data;
  });
      }

  void _agendarCita() async {
    final proxima = await dbHelper.getProximaCitaDisponible();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Cita"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Doctor asignado: ${proxima['doctor']}"),
              const SizedBox(height: 8),
              Text("Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(proxima['fecha']!))}"),
              Text("Hora: ${proxima['hora']}"),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                await dbHelper.addCita(
                  proxima['doctor']!,
                  proxima['fecha']!,
                  proxima['hora']!,
                );
                Navigator.pop(context);
                _loadCitas();
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citas')),
      body: citas.isEmpty
          ? const Center(child: Text("No hay citas registradas"))
          : ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                final cita = citas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.teal),
                    title: Text("Cita con ${cita['doctor']}"),
                    subtitle: Text(
                    "${DateFormat('dd/MM/yyyy').format(DateTime.parse(cita['fecha'] as String))} - ${cita['hora']}"
                      ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agendarCita,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}



// TRATAMIENTO
class TratamientoPage extends StatelessWidget {
  const TratamientoPage({super.key});

  // Lista de medicamentos de ejemplo
  final List<Map<String, String>> medicamentos = const [
    {"nombre": "Paracetamol", "hora": "08:00 AM"},
    {"nombre": "Amoxicilina", "hora": "12:00 PM"},
    {"nombre": "Ibuprofeno", "hora": "06:00 PM"},
    {"nombre": "Vitamina C", "hora": "09:00 PM"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tratamiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Medicamentos y Horarios",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: medicamentos.length,
                itemBuilder: (context, index) {
                  final med = medicamentos[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.medical_services, color: Colors.teal),
                      title: Text(med['nombre']!),
                      subtitle: Text("Tomar a las ${med['hora']}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatologiasPage extends StatelessWidget {
  const PatologiasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Resumen de patologías'));
  }
}

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chat con el bot aquí'));
  }
}

class MapaPage extends StatelessWidget {
  const MapaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Mapa de hospitales'));
  }
}
