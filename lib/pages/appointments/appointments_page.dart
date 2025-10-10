import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../text_styles.dart';
import '../../breakpoints.dart';

class AppointmentsPage extends HookConsumerWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
        constraints: BoxConstraints(maxWidth: Breakpoint.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [Text('Citas', style: HospiredTextStyle.sectionTitle)],
            ),
            const SizedBox(height: 24),
            Text("Solicitudes", style: HospiredTextStyle.body3Bold),
            SizedBox(
              height: 64,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/home/request-appointment',
                    ),
                    child: Text('Solicitar cita'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text("Programadas", style: HospiredTextStyle.body3Bold),
            const SizedBox(height: 24),
            Text("Pasadas", style: HospiredTextStyle.body3Bold),
          ],
        ),
      ),
    );
  }
}
