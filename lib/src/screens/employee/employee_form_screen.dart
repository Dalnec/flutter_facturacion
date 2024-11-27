import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/providers/form_employee_provider.dart';

class EmployeeFormScreen extends StatelessWidget {
  const EmployeeFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeService = Provider.of<EmployeeService>(context);

    return ChangeNotifierProvider(
        create: (_) => EmployeeFormProvider(employeeService.selectedEmployee),
        child: _EmployeeFormProviderBody(employeeService: employeeService));
  }
}

class _EmployeeFormProviderBody extends StatelessWidget {
  final EmployeeService employeeService;

  const _EmployeeFormProviderBody({
    super.key,
    required this.employeeService,
  });

  @override
  Widget build(BuildContext context) {
    final employeeForm = Provider.of<EmployeeFormProvider>(context);
    final employee = employeeForm.employee;
    print("employee.id: ${employee.id} - ${employee.ci}");
    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulario Empleado'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Form(
            key: employeeForm.formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          'Datos Empleado:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        CustomInputField(
                          labelText: 'Carnet de Identidad',
                          helperText: 'Ingresar Numero de Carnet de Identidad',
                          prefixIcon: Icons.contact_emergency_outlined,
                          formProperty: 'ci',
                          initialValue: employee.ci,
                          onChanged: (value) => employee.ci = value,
                          length: 7,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\d{0,9}')),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Nombres',
                          helperText: 'Ingresar Nombres',
                          prefixIcon: Icons.perm_contact_cal_outlined,
                          formProperty: 'names',
                          initialValue: employee.names,
                          onChanged: (value) => employee.names = value,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Apellidos',
                          helperText: 'Ingresar Apellidos',
                          prefixIcon: Icons.perm_contact_cal_outlined,
                          formProperty: 'lastnames',
                          initialValue: employee.lastnames,
                          onChanged: (value) => employee.lastnames = value,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Celular',
                          helperText: 'Ingresar Numero de Celular',
                          prefixIcon: Icons.smartphone_outlined,
                          formProperty: 'phone',
                          initialValue: employee.phone,
                          onChanged: (value) => employee.phone = value,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\d{0,9}')),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Correo',
                          helperText: 'Correo del Empleado',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          formProperty: 'email',
                          initialValue: employee.email,
                          onChanged: (value) => employee.email = value,
                          length: 0,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Direccón',
                          helperText: 'Dirección de Domicilio',
                          prefixIcon: Icons.house_outlined,
                          formProperty: 'address',
                          initialValue: employee.address,
                          onChanged: (value) => employee.address = value,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: 'Perfil',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppTheme.primary,
                            ),
                          ),
                          value: employee.profile,
                          items: const [
                            DropdownMenuItem(
                                value: 2, child: Text('LECTURADOR')),
                            DropdownMenuItem(
                                value: 1, child: Text('ADMINISTRADOR')),
                          ],
                          onChanged: (value) {
                            employee.profile = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: employeeForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (!employeeForm.isValidForm()) {
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
                                  '¿Desea guardar los datos ingresados?',
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
                                  employeeForm.setLoading(true);
                                  Navigator.of(context).pop();
                                  final res = await employeeService
                                      .saveOrCreateEmpleado(employee);
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (res) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Empleado guardado correctamente')),
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Error al guardar el Empleado :(')),
                                    );
                                  }
                                  employeeForm.setLoading(false);
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
                          child: employeeForm.isLoading
                              ? const CircularProgressIndicator(
                                  color: AppTheme.primary,
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
