import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormChangePassword extends StatefulWidget {
  const FormChangePassword({
    super.key,
  });

  @override
  _FormChangePasswordState createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends State<FormChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  bool _isLoading = false;
  // Controladores para los campos de texto
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newRepeatPasswordController =
      TextEditingController();

  Future<void> _savePassword(String newPassword) async {
    setState(() {
      _isLoading = true;
    });
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
    final usuario = usuarioService.selectedUsuario;
    final resp = await usuarioService.changePassword(
      '${usuario.id}',
      newPassword,
    );
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (!resp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cambiar la contraseña')),
      );
      return;
    }
    newPasswordController.clear();
    newRepeatPasswordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contraseña actualizada correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Card(
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Cambiar Contraseña',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: newPasswordController,
                    autofocus: false,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                    onChanged: (value) => setState(() {
                      formData['newPassword'] = value;
                    }),
                    validator: (value) {
                      if (value == null) return 'Campo requerido';
                      return value.length < 4
                          ? 'Debe ser mayor a 4 caracteres'
                          : null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Nueva Contraseña',
                      helperText: 'Nueva Contraseña',
                      prefixIcon: Icon(Icons.password, color: AppTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: newRepeatPasswordController,
                    autofocus: false,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                    onChanged: (value) => setState(() {
                      formData['newRepeatPassword'] = value;
                    }),
                    validator: (value) {
                      if (value == null) return 'Campo requerido';
                      if (value != formData['newPassword']) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Repetir Nueva Contraseña',
                      helperText: 'Repetir Nueva Contraseña',
                      prefixIcon: Icon(Icons.password, color: AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!formKey.currentState!.validate()) {
                      print('Formulario no válido');
                      return;
                    }
                    ModularDialog.showModularDialog(
                      context: context,
                      title: 'Confirmar Acción',
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '¿Esta seguro de cambiar contraseña?',
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
                            Navigator.of(context).pop();
                            await _savePassword(formData['newPassword']);
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
                    child: _isLoading
                        ? const SizedBox(
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
    );
  }
}
