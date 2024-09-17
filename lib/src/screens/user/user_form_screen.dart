import 'package:facturacion/src/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

class UserFormScreen extends StatelessWidget {
  const UserFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final Map<String, String> formValues = {
      'first_name': 'Fernando',
      'last_name': 'Herrera',
      'email': 'tsi@example.com',
      'password': '123456',
      'role': 'Admin'
    };

    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulario de Usuario'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomInputField(
                  labelText: 'Código',
                  helperText: 'Codigo de Usuario',
                  prefixIcon: Icons.credit_card_outlined,
                  formProperty: 'code',
                  formValues: formValues,
                ),
                const SizedBox(height: 10),
                CustomInputField(
                  labelText: 'Familia',
                  helperText: 'Nombre de Familia',
                  prefixIcon: Icons.family_restroom_outlined,
                  formProperty: 'family',
                  formValues: formValues,
                ),
                const SizedBox(height: 10),
                CustomInputField(
                  labelText: 'Direccón',
                  helperText: 'Dirección de Domicilio',
                  prefixIcon: Icons.house_outlined,
                  formProperty: 'address',
                  formValues: formValues,
                ),
                const SizedBox(height: 10),
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
                              'Representante:',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        CustomInputField(
                          labelText: 'Carnet de Identidad',
                          helperText: 'Ingresar Numero de Carnet de Identidad',
                          prefixIcon: Icons.contact_emergency_outlined,
                          formProperty: 'code',
                          formValues: formValues,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Nombre Completo',
                          helperText: 'Ingresar Nombre Completo',
                          prefixIcon: Icons.perm_contact_cal_outlined,
                          formProperty: 'family',
                          formValues: formValues,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Correo',
                          helperText: 'Correo del Usuario',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          formProperty: 'email',
                          formValues: formValues,
                        ),
                        const SizedBox(height: 10),
                        // DropdownButtonFormField(
                        //   value: 'Admin',
                        //   items: const [
                        //     DropdownMenuItem(
                        //         value: 'Admin', child: Text('Admin')),
                        //     DropdownMenuItem(
                        //         value: 'User', child: Text('User')),
                        //   ],
                        //   onChanged: (value) {},
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                  },
                )
              ],
            ),
          ),
        )));
  }
}
