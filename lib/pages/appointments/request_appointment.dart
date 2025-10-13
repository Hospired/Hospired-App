import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../backend-api/api_service.dart';
import '../../backend-api/dtos.dart';
import '../../breakpoints.dart';
import '../../colors.dart';
import '../../providers/patient.dart';
import '../../text_styles.dart';

class RequestAppointment extends HookConsumerWidget {
  const RequestAppointment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(patientProvider);
    final disclaimerShown = useState<bool>(false);
    final requestingAppointment = useState<bool>(false);
    final error = useState<String>("");

    final TextEditingController motiveController = useTextEditingController();

    final callCreateAppointment = useCallback((BuildContext context) async {
      if (patient != null) {
        requestingAppointment.value = true;
        try {
          await ApiService.createAppointment(
            CreateAppointmentReq(
              patientId: patient.id,
              motive: motiveController.text,
              specialty: "General Practice",
            ),
          );
          Navigator.of(context).pop();
        } catch (err) {
          error.value = err.toString();
        } finally {
          requestingAppointment.value = false;
        }
      }
    }, []);

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
                const SizedBox(height: 16),
                Text(
                  'En este formulario puede solicitar una cita médica. Se le asignará el siguiente cupo disponible con el especialista y en el centro de atención que le corresponda, según el motivo que usted describa.\n\nEn casos de emergencia, dirígase al centro de salud más cercano, sin solicitar cita.',
                  textAlign: TextAlign.center,
                  style: HospiredTextStyle.body4,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => disclaimerShown.value = true,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text('Entendido', style: HospiredTextStyle.body3),
                  ),
                ),
                const Spacer(),
              ] else ...[
                Text("Motivo", style: HospiredTextStyle.title3),
                const SizedBox(height: 8),
                TextField(
                  controller: motiveController,
                  readOnly: requestingAppointment.value,
                  //onChanged: (value) => error.value = "",
                  minLines: 3,
                  maxLines: 3,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: "p. ej. dolor abdominal, control prenatal, etc.",
                    labelText: "Motivo de su solicitud",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => callCreateAppointment(context),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text('Solicitar', style: HospiredTextStyle.body3),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    error.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: HospiredColors.danger),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
