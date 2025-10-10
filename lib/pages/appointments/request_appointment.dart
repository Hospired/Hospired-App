import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../colors.dart';
import '../../text_styles.dart';
import '../../breakpoints.dart';

class RequestAppointment extends HookConsumerWidget {
  const RequestAppointment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disclaimerShown = useState<bool>(false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Solicitar Cita'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
          constraints: BoxConstraints(maxWidth: Breakpoint.md),
          child: Column(
            crossAxisAlignment: !disclaimerShown.value
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (!disclaimerShown.value) ...[
                const Spacer(),
                const Icon(
                  Icons.warning,
                  color: HospiredColors.danger,
                  size: 64,
                ),
                Text(
                  'En este formulario puede solicitar una cita médica. Se le asignará el siguiente cupo disponible con el especialista y en el centro de atención que le corresponda, según el motivo que usted describa.\n\nEn casos de emergencia, dirígase al centro de salud más cercano, sin solicitar cita.',
                  textAlign: TextAlign.center,
                  style: HospiredTextStyle.body4,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => disclaimerShown.value = true,
                  child: Text('Entendido', style: HospiredTextStyle.body3),
                ),
                const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
