import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/app_user.dart';
import '../../providers/patient.dart';
import '../../text_styles.dart';
import '../../breakpoints.dart';
import 'next_appointment_card.dart';
import 'user_summary_card.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key, required this.onSelectNavIndex});

  final Function onSelectNavIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider);
    final patient = ref.watch(patientProvider);

    // Fallback, this should never happen as appUser is controlled by the parend widgets
    if (appUser == null || patient == null) {
      return Material();
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
        constraints: BoxConstraints(maxWidth: Breakpoint.md),
        child: Column(
          children: [
            Row(
              children: [
                Text('Bienvenido', style: HospiredTextStyle.sectionTitle),
              ],
            ),
            const SizedBox(height: 8),
            UserSummaryCard(appUser: appUser, patient: patient),
            const SizedBox(height: 16),
            NextAppointmentCard(onTap: () => onSelectNavIndex(1)),
          ],
        ),
      ),
    );
  }
}
