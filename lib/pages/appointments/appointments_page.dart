import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../colors.dart';
import '../../text_styles.dart';
import '../../breakpoints.dart';
import '../../providers/appointments.dart';

class AppointmentsPage extends HookConsumerWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);

    final upcomingAppointments =
        appointments
            ?.where((appointment) => appointment.status == "scheduled")
            .toList() ??
        [];
    final pastAppointments =
        appointments
            ?.where(
              (appointment) =>
                  appointment.status == "completed" ||
                  appointment.status == "canceled" ||
                  appointment.status == "no_show",
            )
            .toList() ??
        [];

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
            const SizedBox(height: 8),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/home/request-appointment',
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        HospiredColors.white,
                      ),
                      elevation: WidgetStateProperty.all(0),
                      fixedSize: WidgetStateProperty.all(const Size(144, 96)),
                    ),
                    child: Text(
                      '+ Solicitar cita',
                      style: HospiredTextStyle.body2Bold.copyWith(
                        color: HospiredColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text("Programadas", style: HospiredTextStyle.body3Bold),
            const SizedBox(height: 8),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (upcomingAppointments.isEmpty) ...[
                    SizedBox(
                      width: 144,
                      height: 96,
                      child: Center(child: Text('No hay citas programadas')),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text("Pasadas", style: HospiredTextStyle.body3Bold),
            const SizedBox(height: 8),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (pastAppointments.isEmpty) ...[
                    SizedBox(
                      width: 144,
                      height: 96,
                      child: Center(child: Text('No hay citas pasadas')),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
