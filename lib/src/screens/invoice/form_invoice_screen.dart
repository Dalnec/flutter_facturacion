import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FormInvoiceScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, String> formValues = {
    'measure': '0',
  };
  FormInvoiceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar Factura"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Informacion de Usuario',
              style: TextStyle(fontSize: 20),
            ),
            const UserCardInfo(showActions: false),
            const SizedBox(height: 10),
            const Text(
              'Nueva Lectura',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15, // soften the shadow
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: CustomInputField(
                  labelText: 'Nuevo Valor',
                  helperText: 'Ingresar Lectura',
                  prefixIcon: Icons.add_chart,
                  formProperty: 'measure',
                  formValues: formValues,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Text("Guardar",
                          style: TextStyle(color: Colors.white)))),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (!formKey.currentState!.validate()) {
                  print('Formulario no válido');
                  return;
                }
                // * Imprimir valores del form
                print(formValues);

                ModularDialog.showModularDialog(
                  context: context,
                  title: 'Registrar Lectura',
                  content: Text(
                      '¿Estás seguro de guardar este valor \nVALOR LECTURA: ${formValues['measure']}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Lógica adicional al confirmar
                      },
                      child: const Text('Confirmar',
                          style: TextStyle(color: AppTheme.harp)),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
