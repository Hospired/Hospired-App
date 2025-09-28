import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // ✅ Se agregó super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospired',
      theme: ThemeData(
        primarySwatch: Colors.teal, // cambia azul por tu color preferido
        scaffoldBackgroundColor: Colors.grey[100], // fondo general
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
        ),
      ),
      home: const HomePage(), // ✅ Llamada const appBar
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // ✅ Se agregó super.key

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
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
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

// Pantallas individuales
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key}); // ✅ Se agregó super.key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //EDITAR LOSAPPBAR
      title: const Text('Perfil'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // acción al pulsar editar
          },
        ),
      ],
      elevation: 2,
      backgroundColor: Colors.teal,
    ),

      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.teal[50],
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Nombre: José López"),
              subtitle: const Text("Usuario: jose123"),
            ),
          ),
          Card(
            color: Colors.teal[50],
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.badge),
              title: const Text("Cédula: 1234567890"),
            ),
          ),
          // más cards para edad, sexo, etc.
        ],
      ),
    ),
    );
  }
}

class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citas')),
      body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Cita con Dr. Pérez'),
            subtitle: Text('12/10/2025 - 10:00 AM'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Cita con Dra. Martínez'),
            subtitle: Text('15/10/2025 - 4:00 PM'),
          ),
        ),
      ],
    ),

    );
  }
}

class TratamientoPage extends StatelessWidget {
  const TratamientoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tratamiento')),
      body: const Center(child: Text('Ver tratamiento actual')),
    );
  }
}

class PatologiasPage extends StatelessWidget {
  const PatologiasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patologías')),
      body: const Center(child: Text('Resumen de patologías')),
    );
  }
}

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Bot')),
      body: const Center(child: Text('Chat con el bot aquí')),
    );
  }
}

class MapaPage extends StatelessWidget {
  const MapaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: const Center(child: Text('Mapa de hospitales o clínicas')),
    );
  }
}
