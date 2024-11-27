import 'package:facturacion/src/providers/form_settings_provider.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/services/services.dart';

class MonitoringSettingsFormScreen extends StatelessWidget {
  const MonitoringSettingsFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final districService = Provider.of<DistricService>(context);

    return ChangeNotifierProvider(
        create: (_) => SettingsFormProvider(districService.settings),
        child: _SettingsFormBody(districService: districService));
  }
}

class _SettingsFormBody extends StatelessWidget {
  final DistricService districService;

  const _SettingsFormBody({
    super.key,
    required this.districService,
  });

  @override
  Widget build(BuildContext context) {
    final settingsForm =
        Provider.of<SettingsFormProvider>(context, listen: false);
    final settings = settingsForm.settings;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuracion Monitoreo'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: settingsForm.formKey,
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              // 'Datos de Compra:',
                              'Editar Datos',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomInputField(
                          labelText: 'Intervalo de Envio',
                          helperText: 'Ingresar Tiempo en minutos',
                          prefixIcon: Icons.timer_outlined,
                          formProperty: 'intervalTimeDevice',
                          initialValue: settings.intervalTimeDevice,
                          onChanged: (value) =>
                              settings.intervalTimeDevice = value,
                          length: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\d{0,9}'))
                          ],
                        ),
                        const SizedBox(height: 10),
                        // RadioTimer(),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Altura del Tanque',
                          helperText: 'Ingresar altura en centimetros',
                          prefixIcon: Icons.height_outlined,
                          formProperty: 'height',
                          initialValue: double.parse(settings.height ?? '0')
                              .toStringAsFixed(2),
                          onChanged: (value) => settings.height = value,
                          length: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          labelText: 'Ancho del Tanque',
                          helperText: 'Ingresar ancho en centimetros',
                          prefixIcon: Icons.width_full,
                          formProperty: 'height',
                          initialValue: double.parse(settings.width ?? '0')
                              .toStringAsFixed(2),
                          onChanged: (value) => settings.width = value,
                          length: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: settingsForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (!settingsForm.isValidForm()) {
                            print('Formulario no válido');
                            return;
                          }
                          ModularDialog.showModularDialog(
                            context: context,
                            title: 'Confirmar Acción',
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '¿Desea actualizar este valor?',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  settingsForm.setLoading(true);
                                  Navigator.of(context).pop();
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  final resp = await districService
                                      .updateSettings(settings);
                                  settingsForm.setLoading(false);
                                  if (!resp) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Error al realizar la acción')),
                                    );
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Acción realizada correctamente')),
                                  );
                                  Navigator.pop(context, 'reload');
                                },
                                child: const Text('Confirmar',
                                    style: TextStyle(color: AppTheme.harp)),
                              ),
                            ],
                          );
                        },
                  child: SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: settingsForm.isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primary,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text("Guardar",
                                  style: TextStyle(color: Colors.white)))),
                )
              ],
            ),
          ),
        )));
  }
}

enum TimerType { segundos, minutos }

class RadioTimer extends StatefulWidget {
  const RadioTimer({super.key});

  @override
  State<RadioTimer> createState() => _RadioTimerState();
}

class _RadioTimerState extends State<RadioTimer> {
  TimerType? _character = TimerType.minutos;

  @override
  Widget build(BuildContext context) {
    final settingsForm =
        Provider.of<SettingsFormProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Segundos'),
          leading: Radio<TimerType>(
            value: TimerType.segundos,
            groupValue: _character,
            onChanged: (TimerType? value) {
              setState(() {
                print("value $value");
                _character = value;
                settingsForm.setTimerInterval('sec');
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Minutos'),
          leading: Radio<TimerType>(
            value: TimerType.minutos,
            groupValue: _character,
            onChanged: (TimerType? value) {
              setState(() {
                _character = value;
                settingsForm.setTimerInterval('min');
              });
            },
          ),
        ),
      ],
    );
  }
}
