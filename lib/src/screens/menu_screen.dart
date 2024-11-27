import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/widgets/widgets.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facturación"),
        actions: [
          IconButton(
              onPressed: () {
                ModularDialog.showModularDialog(
                  context: context,
                  title: 'Confirmar Acción',
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '¿Desea Cerrar Sesión?',
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
                        await Provider.of<AuthService>(context, listen: false)
                            .logout();
                        // Navigator.pushReplacementNamed(context, 'login');
                        Navigator.pushNamedAndRemoveUntil(
                            context, "login", (r) => false);
                      },
                      child: const Text('Confirmar',
                          style: TextStyle(color: AppTheme.harp)),
                    ),
                  ],
                );
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: const Stack(
        children: [
          //Background
          Background(),
          //HomeBody
          _HomeBody(),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          // PageTitle(),
          // Cards
          CardTable()
        ],
      ),
    );
  }
}
