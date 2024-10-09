import 'package:facturacion/src/providers/form_usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/widgets/custom_input_field.dart';

class UserFormScreen extends StatelessWidget {
  const UserFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);

    return ChangeNotifierProvider(
        create: (_) => UsuarioFormProvider(usuarioService.selectedUsuario),
        child: _UserFormProviderBody(usuarioService: usuarioService));
  }
}

class _UserFormProviderBody extends StatelessWidget {
  final UsuarioService usuarioService;

  const _UserFormProviderBody({
    super.key,
    required this.usuarioService,
  });

  @override
  Widget build(BuildContext context) {
    final usuarioForm = Provider.of<UsuarioFormProvider>(context);
    final usuario = usuarioForm.usuario;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulario de Usuario'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: usuarioForm.formKey,
            child: Column(
              children: [
                // CustomInputField(
                //   labelText: 'Código',
                //   helperText: 'Codigo de Usuario',
                //   prefixIcon: Icons.credit_card_outlined,
                //   formProperty: 'code',
                //   initialValue: '${usuario.id}',
                //   onChanged: (value) => usuario.id = int.parse(value),
                // ),

                const SizedBox(height: 10),
                CustomInputField(
                  labelText: 'Familia',
                  helperText: 'Nombre de Familia',
                  prefixIcon: Icons.family_restroom_outlined,
                  formProperty: 'family',
                  initialValue: usuario.family,
                  onChanged: (value) => usuario.family = value,
                ),
                const SizedBox(height: 10),
                CustomInputField(
                  labelText: 'Direccón',
                  helperText: 'Dirección de Domicilio',
                  prefixIcon: Icons.house_outlined,
                  formProperty: 'address',
                  initialValue: usuario.address,
                  onChanged: (value) => usuario.address = value,
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
                          formProperty: 'ci',
                          initialValue: usuario.ci,
                          onChanged: (value) => usuario.ci = value,
                          length: 7,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Nombres',
                          helperText: 'Ingresar Nombres',
                          prefixIcon: Icons.perm_contact_cal_outlined,
                          formProperty: 'names',
                          initialValue: usuario.names,
                          onChanged: (value) => usuario.names = value,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Apellidos',
                          helperText: 'Ingresar Apellidos',
                          prefixIcon: Icons.perm_contact_cal_outlined,
                          formProperty: 'lastnames',
                          initialValue: usuario.lastnames,
                          onChanged: (value) => usuario.lastnames = value,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Celular',
                          helperText: 'Ingresar Numero de Celular',
                          prefixIcon: Icons.perm_contact_cal_outlined,
                          formProperty: 'phone',
                          initialValue: usuario.phone,
                          onChanged: (value) => usuario.phone = value,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Correo',
                          helperText: 'Correo del Usuario',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          formProperty: 'email',
                          initialValue: usuario.email,
                          onChanged: (value) => usuario.email = value,
                          length: 0,
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
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!usuarioForm.isValidForm()) {
                      print('Formulario no válido');
                      return;
                    }
                    print('Formulario válido! Wiiii!');
                    await usuarioService.saveOrCreateUsuario(usuario);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      'user',
                      (route) => route.isFirst,
                    );
                  },
                )
              ],
            ),
          ),
        )));
  }
}
