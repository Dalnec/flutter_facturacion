import 'package:facturacion/src/providers/bottom_navigation_bar_provider.dart';
import 'package:facturacion/src/screens/screens.dart'
    show FormInvoiceScreen, UserInfoInvoiceScreen;
import 'package:facturacion/src/services/auth_service.dart';
import 'package:facturacion/src/services/purchase_service.dart';
import 'package:facturacion/src/widgets/widgets.dart' show CustomNavigatorBar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeInvoiceScreen extends StatefulWidget {
  const HomeInvoiceScreen({super.key});

  @override
  State<HomeInvoiceScreen> createState() => _HomeInvoiceScreenState();
}

class _HomeInvoiceScreenState extends State<HomeInvoiceScreen> {
  @override
  void initState() {
    super.initState();
    // Usar addPostFrameCallback para esperar que el build termine antes de modificar el estado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bottomNavigationProvider =
          Provider.of<BottomNavigationProvider>(context, listen: false);
      bottomNavigationProvider.selectedMenuOpt = 0; // Resetear el currentIndex
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigatorBar(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el selectedMenuOpt del provider
    final bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context);
    Provider.of<PurchaseService>(context, listen: false).getLastPurchase();
    Provider.of<AuthService>(context, listen: false).readProfile();
    // Cambiar para mostrar la pagina respectiva
    final currentIndex = bottomNavigationProvider.selectedMenuOpt;
    switch (currentIndex) {
      case 0:
        return const UserInfoInvoiceScreen();
      case 1:
        return FormInvoiceScreen();
      default:
        return const UserInfoInvoiceScreen();
    }
  }
}
