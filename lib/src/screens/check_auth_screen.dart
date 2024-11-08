import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/screens/screens.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: authService.readToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return const Text('Espere...');
          }
          if (snapshot.data == '') {
            Future.microtask(() {
              // Destruye la transicion de una pagina a otra
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionDuration: const Duration(seconds: 0),
                  ));
            });
          } else {
            List<String> parts = snapshot.data!.split(';');
            if (parts[2] == 'USUARIO') {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const UserInfoScreen(),
                      transitionDuration: const Duration(seconds: 0),
                    ));
              });
            } else {
              if (parts[2] == 'COBRADOR') {
                Future.microtask(() {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const InvoiceScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ));
                });
              } else {
                Future.microtask(() {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const MenuScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ));
                });
              }
            }
          }
          return Container();
        },
      ),
    ));
  }
}
