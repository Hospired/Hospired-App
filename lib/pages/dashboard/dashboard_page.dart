import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../colors.dart';
import '../../providers/app_user.dart';
import '../../text_styles.dart';
import '../../breakpoints.dart';
import 'user_summary_card.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider);

    // Fallback just in case, this should never happen
    if (appUser == null) {
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
            UserSummaryCard(appUser: appUser),
          ],
        ),
      ),
    );
  }
}
