import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/auth_service.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/services/services.dart' show UsuarioService;
import 'package:facturacion/src/widgets/widgets.dart'
    show InvoiceDataTable, CardInfoUserInvoice, ModularDialog;

class UserInfoInvoiceScreen extends StatelessWidget {
  const UserInfoInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final profile = authService.profileStorage;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Usuario'),
        actions: [
          if (profile == 'ADMINISTRADOR')
            IconButton(
              onPressed: () {
                double lectura = 0.0;
                if (!usuarioService.selectedUsuario.restart) {
                  ModularDialog.showModularDialog(
                    context: context,
                    title: 'Reiniciar Valor Medidor',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'En caso de haber una lectura pendiente, deberá registrarla.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Valor de Lectura',
                            prefixIcon: Icon(Icons.add_chart),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                          onChanged: (value) {
                            if (value.isEmpty) return;
                            lectura = double.parse(value);
                          },
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
                          await Future.delayed(const Duration(seconds: 1));
                          print("lectura: $lectura");
                          final value = UsuarioDetail(
                            description:
                                'Lectura Anterior al Reinicio del Medidor',
                            price: '0',
                            quantity: '$lectura',
                            isIncome: true,
                            status: true,
                            usuario: usuarioService.selectedUsuario.id!,
                          );
                          final response =
                              await usuarioService.restartUsuarioDetail(
                            usuarioService.selectedUsuario.id!,
                            value,
                          );
                          if (!response) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error al reiniciar el valor')),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Cambios realizados correctamente')),
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirmar',
                            style: TextStyle(color: AppTheme.harp)),
                      ),
                    ],
                  );
                } else {
                  ModularDialog.showModularDialog(
                    context: context,
                    title: 'Revertir Reinicio',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'No reiniciar el valor del medidor en la siguiente lectura.',
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
                          await Future.delayed(const Duration(seconds: 1));
                          print("lectura: $lectura");
                          final usuario = usuarioService.selectedUsuario.copy();
                          usuario.restart = false;
                          await usuarioService.saveOrCreateUsuario(usuario);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Cambios realizados correctamente')),
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirmar',
                            style: TextStyle(color: AppTheme.harp)),
                      ),
                    ],
                  );
                }
              },
              icon: const Icon(
                Icons.restore_outlined,
                color: Colors.white,
              ),
            ),
          if (profile == 'ADMINISTRADOR')
            IconButton(
                onPressed: () {
                  print(usuarioService.selectedUsuario.toJson());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UsuarioDetailsScreen()),
                  );
                },
                icon: const Icon(
                  Icons.format_list_bulleted_outlined,
                  color: Colors.white,
                )),
        ],
      ),
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 5),
                child: Column(
                  children: [
                    CardInfoUserInvoice(
                        usuario: usuarioService.selectedUsuario),
                  ],
                ),
              ),
            )
          ];
        },
        body: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
          child: InvoiceDataTable(usuario: usuarioService.selectedUsuario),
        ),
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  final double? height;

  const _CardContainer({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      padding: const EdgeInsets.all(8),
      // width: 300,
      height: height ?? null,
      decoration: _createCardShape(),
      child: child,
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      );
}
