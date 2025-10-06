import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (index) => onTap(index),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.space_dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Citas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Tratamiento',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
