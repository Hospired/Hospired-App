import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../backend-api/api_service.dart';
import '../../backend-api/dtos.dart';
import '../../breakpoints.dart';
import '../../colors.dart';
import '../../openai_configuration.dart';
import '../../providers/patient.dart';
import '../../text_styles.dart';

const String prePrompt = '''
Eres una IA que le ayuda a pacientes agendar citas médicas en hospitales mediante un sistema digital llamado hospired.
Los pacientes escribirán el motivo de su cita. Tú le responderás que tipo de especialista le corresponde al paciente
según la descripción que haya dado. Si la descripción es muy inexacta, puedes solicitarle al paciente que describa su
problema mas detalladamente. Solo les puede preguntar 1 vez. Si no puedes determinar la especialidad después de la segunda
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

En la respuesta, traduce la especialidad al español.
''';

Future<String?> callOpenAI(List<Map<String, String>> messages) async {
  final apiKey = openAiApiKeyDev;
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  /*
  [
    {'role': 'user', 'content': 'Hello!'},
  ]
  */

  final body = jsonEncode({
    'model': 'gpt-3.5-turbo',
    'messages': messages,
    'temperature': 0.7,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data['choices'][0]['message']['content']);
    return data['choices'][0]['message']['content'];
  } else {
    print('Error: ${response.statusCode}');
    print(response.body);
  }
}

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

    final TextEditingController motiveController = useTextEditingController();

    final callOpenAi = useCallback(() async {
      List<Map<String, String>> currentMessages = [...messages.value];
      currentMessages.add({'role': 'user', 'content': motiveController.text});
      String? assistantResponse = await callOpenAI(currentMessages);
      if (assistantResponse != null) {
        currentMessages.add({
          'role': 'assistant',
          'content': assistantResponse,
        });
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
                SizedBox(
                  height: 192,
                  child: Text(
                    messages.value.isNotEmpty && messages.value.length > 2
                        ? messages.value.last['content'] ?? ''
                        : '',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => callOpenAi(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text('Call OpenAi', style: HospiredTextStyle.body3),
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
