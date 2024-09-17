import 'package:facturacion/src/screens/screens.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facturacion App',
      initialRoute: 'login',
      routes: {
        // 'ckeckAuth': (context) => const CheckAuthScreen(),
        'login': (context) => const LoginScreen(),
        'menu': (context) => const MenuScreen(),
        'user': (context) => const UserScreen(),
        'userform': (context) => const UserFormScreen(),
        'userinfo': (context) => const UserInfoScreen(),
        'invoice': (context) => InvoiceScreen(),
        'invoiceform': (context) => FormInvoiceScreen(),
        'monitoring': (context) => const MonitoringScreen(),
        'district': (context) => const DistricScreen(),
        'purchase': (context) => const PurchaseScreen(),
      },
      theme: AppTheme.lightTheme,
    );
  }
}
