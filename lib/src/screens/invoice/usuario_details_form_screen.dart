import 'package:facturacion/src/providers/form_usuario_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:facturacion/src/services/services.dart';

class UsuarioDetailsFormScreen extends StatelessWidget {
  const UsuarioDetailsFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioDetailService =
        Provider.of<UsuarioDetailDetailService>(context);

    return ChangeNotifierProvider(
        create: (_) => UsuarioDetailFormProvider(
            usuarioDetailService.selectedUsuarioDetail),
        child: _UsuarioDetailFormProviderBody(
            usuarioDetailService: usuarioDetailService));
  }
}

class _UsuarioDetailFormProviderBody extends StatelessWidget {
  final UsuarioDetailDetailService usuarioDetailService;

  const _UsuarioDetailFormProviderBody({
    super.key,
    required this.usuarioDetailService,
  });

  @override
  Widget build(BuildContext context) {
    final detailForm = Provider.of<UsuarioDetailFormProvider>(context);
    final detail = detailForm.usuarioDetail;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulario Detalle Usuario'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Form(
            key: detailForm.formKey,
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
                          'Engresar Datos:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: 'Tipo',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.multiple_stop_outlined,
                              color: AppTheme.primary,
                            ),
                          ),
                          value: detail.isIncome,
                          items: const [
                            DropdownMenuItem(
                                value: true, child: Text('Ingreso')),
                            DropdownMenuItem(
                                value: false, child: Text('Egreso')),
                          ],
                          onChanged: (value) {
                            detail.isIncome = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Descripción',
                          helperText: 'Descripción del Registro',
                          prefixIcon: Icons.description_outlined,
                          formProperty: 'description',
                          initialValue: detail.description,
                          onChanged: (value) => detail.description = value,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Cantidad',
                          helperText: 'Ingresar Cantidad',
                          prefixIcon: Icons.balance_outlined,
                          formProperty: 'quantity',
                          initialValue: detail.quantity,
                          onChanged: (value) => detail.quantity = value,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                          length: 1,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Precio',
                          helperText: 'Ingresar Precio',
                          prefixIcon: Icons.attach_money_outlined,
                          formProperty: 'price',
                          initialValue: detail.price,
                          onChanged: (value) => detail.price = value,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                          ],
                          length: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: detailForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (!detailForm.isValidForm()) {
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
                                  detailForm.setLoading(true);
                                  Navigator.of(context).pop();
                                  final res = await usuarioDetailService
                                      .saveOrCreateUsuarioDetail(detail);
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (res != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Datos guardados correctamente')),
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Error al guardar el Datos :(')),
                                    );
                                  }
                                  detailForm.setLoading(false);
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
                          child: detailForm.isLoading
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
