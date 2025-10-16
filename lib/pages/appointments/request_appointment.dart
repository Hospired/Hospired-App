import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../backend-api/api_service.dart';
import '../../backend-api/dtos.dart';
import '../../backend-api/enum_maps.dart';
import '../../breakpoints.dart';
import '../../colors.dart';
import '../../providers/patient.dart';
import '../../text_styles.dart';
import '../../utilities/openai.dart';

const String prePrompt = '''
Eres una IA que le ayuda a pacientes agendar citas médicas en hospitales mediante un sistema digital llamado hospired.
Los pacientes escribirán el motivo de su cita. Tú le responderás que tipo de especialista le corresponde al paciente
según la descripción que haya dado. Si la descripción es muy inexacta, puedes solicitarle al paciente que describa su
problema mas detalladamente. Solo le puedes preguntar 1 vez. Si no puedes determinar la especialidad después de la segunda
respuesta, contesta que no es posible determinar la especialidad, y recomienda ver un médico general.

La lista de las especialidades, según la base de datos, es la siguiente:
  'General Practice',
  'Internal Medicine',
  'Family Medicine',
  'Pediatrics',
  'Cardiology',
  'Dermatology',
  'Neurology',
  'Psychiatry',
  'Oncology',
  'Orthopedics',
  'Radiology',
  'Anesthesiology',
  'Emergency Medicine',
  'Surgery',
  'Gynecology',
  'Urology',
  'Ophthalmology',
  'Otolaryngology'

En la respuesta, traduce la especialidad al español. No ingreses caracteres de formatear texto, como
por ejemplo **, <H1>, etc., solo plain text.

Para la primera respuesta, existe la siguiente regla:
Formula siempre una frase respondiendole al usuario. Si requieres mas información, termina tu respuesta
con exactamente el siguiente string: ##More_Information_Required.
Si sabes que especialidad proponer, termina tu respuesta con ##<specialty> reemplazando a <specialty>
con un una especialidad de la lista, con su nombre original, por ejemplo ##Neurology.

Para la segunda respuesta, existe la siguiente regla:
Formula siempre una frase respondiendole al usuario. Si sabes que especialidad proponer, termina tu
respuesta con ##<specialty> reemplazando a <specialty> con un una especialidad de la lista, con su
nombre original, por ejemplo ##Neurology.
Si no sabes qué especialidad proponer, termina la respuesta con ##General Practice
''';

class RequestAppointment extends HookConsumerWidget {
  const RequestAppointment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(patientProvider);
    final disclaimerShown = useState<bool>(false);
    final requestingAppointment = useState<bool>(false);
    final messages = useState<List<Map<String, String>>>([
      {'role': 'system', 'content': prePrompt},
    ]);
    final error = useState<String>("");
    final inputMoreInformation = useState<bool>(false);
    final selectedSpecialty = useState<String>("");
    final readyToSubmit = useState<bool>(false);

    final TextEditingController motiveController = useTextEditingController();
    final TextEditingController moreInfoController = useTextEditingController();

    final callOpenAi = useCallback(() async {
      List<Map<String, String>> currentMessages = [...messages.value];

      if (inputMoreInformation.value) {
        currentMessages.add({
          'role': 'user',
          'content': moreInfoController.text,
        });
      } else {
        currentMessages.add({'role': 'user', 'content': motiveController.text});
      }

      String? assistantResponse = await requestOpenAiResponse(currentMessages);
      if (assistantResponse != null) {
        List<String> splittedResponse = assistantResponse.split('##');
        if (splittedResponse.length == 2) {
          if (splittedResponse[1].contains('More_Information_Required')) {
            inputMoreInformation.value = true;
          } else {
            if (medicalSpecialties.keys.contains(splittedResponse[1])) {
              selectedSpecialty.value = splittedResponse[1];
              readyToSubmit.value = true;
            }
          }
        }

        currentMessages.add({
          'role': 'assistant',
          'content': splittedResponse[0],
        });
        if (currentMessages.length > 4) {
          readyToSubmit.value = true;
        }

        messages.value = [...currentMessages];
      }
    }, []);

    final callCreateAppointment = useCallback((BuildContext context) async {
      if (patient != null) {
        requestingAppointment.value = true;
        try {
          await ApiService.createAppointment(
            CreateAppointmentReq(
              patientId: patient.id,
              motive: motiveController.text,
              specialty: selectedSpecialty.value,
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
                : CrossAxisAlignment.stretch,
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
                  readOnly:
                      requestingAppointment.value ||
                      inputMoreInformation.value ||
                      readyToSubmit.value,
                  minLines: 3,
                  maxLines: 3,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: "p. ej. dolor abdominal, control prenatal, etc.",
                    labelText: "Motivo de su solicitud",
                    border: OutlineInputBorder(),
                  ),
                ),
                if (messages.value.length > 2) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 96,
                    child: Text(messages.value[2]['content'] ?? ''),
                  ),
                ],
                if (inputMoreInformation.value) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: moreInfoController,
                    readOnly:
                        requestingAppointment.value ||
                        messages.value.length > 5 ||
                        readyToSubmit.value,
                    minLines: 3,
                    maxLines: 3,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: "",
                      labelText: "Describe tu problema mas detalladamente",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (messages.value.length > 4) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 96,
                      child: Text(messages.value[4]['content'] ?? ''),
                    ),
                  ],
                ],
                if (!readyToSubmit.value) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => callOpenAi(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        'Consultar IA Hospired',
                        style: HospiredTextStyle.body3,
                      ),
                    ),
                  ),
                ],

                if (readyToSubmit.value) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Especialidad",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    initialValue: selectedSpecialty.value.isNotEmpty
                        ? selectedSpecialty.value
                        : 'General Practice',
                    onChanged: (String? specialty) {
                      if (specialty != null) {
                        selectedSpecialty.value = specialty;
                      }
                    },
                    items: medicalSpecialties.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => callCreateAppointment(context),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text('Solicitar', style: HospiredTextStyle.body3),
                    ),
                  ),
                ],
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
