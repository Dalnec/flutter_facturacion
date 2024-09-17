import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UserCardInfo extends StatelessWidget {
  final bool showActions;

  const UserCardInfo({
    super.key,
    this.showActions = true,
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
        child: _UserInfo(showActions: showActions),
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
  final bool showActions;

  const _UserInfo({
    super.key,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rowInfo(Icons.family_restroom_outlined, "Fam. Perez Guevara"),
        const SizedBox(height: 5),
        _rowInfo(Icons.house,
            "Calle Guadalupe esq. juan pablo Ise gundo fi tercero #90"),
        const SizedBox(height: 5),
        _rowInfo(Icons.phone, "65381838"),
        // Action Buttons
        if (showActions)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'userform');
                },
                icon: const Icon(Icons.edit, color: AppTheme.warning, size: 25),
              ),
              IconButton(
                onPressed: () {},
                icon:
                    const Icon(Icons.check, color: AppTheme.success, size: 25),
              ),
              IconButton(
                onPressed: () {
                  ModularDialog.showModularDialog(
                    context: context,
                    title: 'Eliminar Usuario',
                    content:
                        const Text('¿Estás seguro de que deseas continuar?'),
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
                icon: const Icon(Icons.delete, color: AppTheme.error, size: 25),
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
