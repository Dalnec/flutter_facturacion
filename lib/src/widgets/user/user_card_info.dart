import 'package:facturacion/src/services/services.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:facturacion/src/models/models.dart' show Usuario;

class UserCardInfo extends StatelessWidget {
  final Usuario usuario;
  final UsuarioService service;

  const UserCardInfo({
    super.key,
    required this.usuario,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('card_container'),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        width: double.infinity,
        decoration: _createCardShape(),
        child: _UserInfo(usuario: usuario, service: service),
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15, // soften the shadow
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      );
}

class _UserInfo extends StatelessWidget {
  final Usuario usuario;
  final UsuarioService service;

  const _UserInfo({
    super.key,
    required this.usuario,
    required this.service,
  });

  void onPressed(usuarioService, context) async {
    final status = usuario.status == 'A' ? 'I' : 'A';
    final resp = await usuarioService.changeUsuarioStatus(usuario.id, status);
    if (resp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cambio de estado realizado correctamente')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cambiar el estado')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rowInfo(Icons.family_restroom_outlined, usuario.family),
        const SizedBox(height: 5),
        _rowInfo(Icons.house, usuario.address),
        const SizedBox(height: 5),
        _rowInfo(Icons.phone, usuario.phone),
        _rowInfo(Icons.person,
            '${usuario.ci} - ${usuario.names} ${usuario.lastnames}'),
        const SizedBox(height: 5),
        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                service.selectedUsuario = usuario.copy();
                Navigator.pushNamed(context, 'userform');
              },
              icon: const Icon(Icons.edit, color: AppTheme.warning, size: 25),
              label: const Text("Editar",
                  style: TextStyle(color: AppTheme.warning)),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Colors.transparent), // Fondo transparente
                foregroundColor: WidgetStateProperty.all(
                    AppTheme.warning), // Color del texto y del ícono
                overlayColor: WidgetStateProperty.all(
                    AppTheme.warning.withOpacity(0.1)), // Efecto al hacer clic
              ),
            ),
            usuario.status == 'A'
                ? ElevatedButton.icon(
                    onPressed: () {
                      ModularDialog.showModularDialog(
                        context: context,
                        title: 'Inhabilitar Usuario',
                        content:
                            const Text('¿Deseas inhabilitar este usuario?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              onPressed(service, context);
                            },
                            child: const Text('Confirmar',
                                style: TextStyle(color: AppTheme.harp)),
                          ),
                        ],
                      );
                    },
                    icon: const Icon(Icons.block,
                        color: AppTheme.error, size: 25),
                    label: const Text("Inhabilitar",
                        style: TextStyle(color: AppTheme.error)),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      foregroundColor: WidgetStateProperty.all(Colors.red),
                      overlayColor:
                          WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      ModularDialog.showModularDialog(
                        context: context,
                        title: 'Habilitar Usuario',
                        content: const Text('¿Deseas habilitar este usuario?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              onPressed(service, context);
                            },
                            child: const Text('Confirmar',
                                style: TextStyle(color: AppTheme.harp)),
                          ),
                        ],
                      );
                    },
                    icon: Icon(Icons.block, color: AppTheme.success, size: 25),
                    label: Text("Habilitar",
                        style: TextStyle(color: AppTheme.success)),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      foregroundColor:
                          WidgetStateProperty.all(AppTheme.success),
                      overlayColor: WidgetStateProperty.all(
                          AppTheme.success.withOpacity(0.1)),
                    ),
                  ),
          ],
        )
      ],
    );
  }

  Row _rowInfo(IconData icon, text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primary,
          size: 30,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 270,
          child: Text(text,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
