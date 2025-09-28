import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

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

// ===================== DATABASE HELPER =====================

class DatabaseHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'hospired.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cedula TEXT UNIQUE,
            password TEXT
          )
        ''');

        await db.insert('usuarios', {'cedula': '1234567890', 'password': '1234'});
      },
    );
  }

  Future<Map<String, dynamic>?> login(String cedula, String password) async {
    final db = await database;
    final res = await db.query(
      'usuarios',
      where: 'cedula = ? AND password = ?',
      whereArgs: [cedula, password],
    );
    return res.isNotEmpty ? res.first : null;
  }
}

// ===================== LOGIN PAGE =====================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  String error = "";
  bool loading = false;

  void _login() async {
    FocusScope.of(context).unfocus();
    setState(() => loading = true);

    final user = await dbHelper.login(
      cedulaController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => loading = false);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogged', true);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => error = "Cédula o contraseña incorrecta");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('H O S P I R E D')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cedulaController,
              decoration: const InputDecoration(
                labelText: "Número de Identificación",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
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
    );
  }
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

class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Lista de citas'));
  }
}

class TratamientoPage extends StatelessWidget {
  const TratamientoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Tratamientos asignados'));
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
