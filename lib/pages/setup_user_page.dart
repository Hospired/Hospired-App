import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../backend-api/api_service.dart';
import '../backend-api/dtos.dart';
import '../colors.dart';
import '../providers/app_user.dart';
import '../providers/auth_user.dart';
import '../text_styles.dart';
import '../ui/alert_dialogs.dart';

class SetupUserPage extends HookConsumerWidget {
  const SetupUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authUserProvider);

    final creatingUser = useState<bool>(false);
    final error = useState<String>("");

    final TextEditingController firstNameController =
        useTextEditingController();
    final TextEditingController secondNameController =
        useTextEditingController();
    final TextEditingController firstLastNameController =
        useTextEditingController();
    final TextEditingController secondLastNameController =
        useTextEditingController();
    final dateOfBirth = useState<DateTime?>(null);

    Future<void> pickDateOfBirth(BuildContext context) async {
      final now = DateTime.now();
      final initialDate = dateOfBirth.value ?? DateTime(now.year - 18);
      final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: now,
        locale: const Locale('es'),
      );

      if (newDate != null) {
        dateOfBirth.value = newDate;
      }
    }

    final showIncompleteUserInputsDialog = useCallback((
      BuildContext context,
    ) async {
      await warningDialog(
        context: context,
        title: "Datos incompletos",
        infoText: "Debe ingresar mínimo un nombre y un apellido.",
      );
    }, []);

    final callCreateAppUser = useCallback((BuildContext context) async {
      String firstName = firstNameController.text;
      String secondName = secondNameController.text;
      String firstLastName = firstLastNameController.text;
      String secondLastName = secondLastNameController.text;

      if (firstName.isEmpty || firstLastName.isEmpty) {
        await showIncompleteUserInputsDialog(context);
        return;
      }
      if (authUser != null) {
        creatingUser.value = true;
        error.value = "";
        try {
          final AppUserRes createdUser = await ApiService.createAppUser(
            CreateAppUserReq(
              id: authUser.id,
              firstName: firstName,
              secondName: secondName,
              firstLastName: firstLastName,
              secondLastName: secondLastName,
              dateOfBirth: dateOfBirth.value,
            ),
          );
          ref.read(appUserProvider.notifier).set(createdUser);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } catch (err) {
          error.value = err.toString();
        } finally {
          creatingUser.value = false;
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('H O S P I R E D')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Configurar Usuario", style: HospiredTextStyle.title4),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Text(
                    authUser != null ? "Correo electrónico:" : "",
                    style: HospiredTextStyle.title2,
                  ),
                  const SizedBox(width: 12),
                  Text(authUser?.email ?? ""),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    Text("Nombres", style: HospiredTextStyle.title3),
                    const SizedBox(height: 8),
                    TextField(
                      controller: firstNameController,
                      readOnly: creatingUser.value,
                      onChanged: (value) => error.value = "",
                      decoration: const InputDecoration(
                        labelText: "Primer Nombre",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: secondNameController,
                      readOnly: creatingUser.value,
                      onChanged: (value) => error.value = "",
                      decoration: const InputDecoration(
                        labelText: "Segundo Nombre",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text("Apellidos", style: HospiredTextStyle.title3),
                    const SizedBox(height: 8),
                    TextField(
                      controller: firstLastNameController,
                      readOnly: creatingUser.value,
                      onChanged: (value) => error.value = "",
                      decoration: const InputDecoration(
                        labelText: "Primer Apellido",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: secondLastNameController,
                      readOnly: creatingUser.value,
                      onChanged: (value) => error.value = "",
                      decoration: const InputDecoration(
                        labelText: "Segundo Apellido",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Fecha de nacimiento",
                      style: HospiredTextStyle.title3,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => pickDateOfBirth(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: dateOfBirth.value != null
                              ? "Fecha de nacimiento"
                              : "",
                          border: const OutlineInputBorder(),
                        ),
                        child: Text(
                          dateOfBirth.value != null
                              ? "${dateOfBirth.value!.day}/${dateOfBirth.value!.month}/${dateOfBirth.value!.year}"
                              : "Seleccionar",
                          style: TextStyle(
                            color: dateOfBirth.value != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: creatingUser.value
                          ? null
                          : () => callCreateAppUser(context),
                      child: const Text("Continuar"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        error.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: HospiredColors.danger),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
