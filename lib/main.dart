import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/screens/screens.dart';
import 'package:facturacion/src/themes/theme.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MonitoringService(),
        ),
        ChangeNotifierProvider(
          create: (_) => DistricService(),
        ),
        ChangeNotifierProvider(
          create: (_) => InvoiceService(),
        ),
        ChangeNotifierProvider(
          create: (_) => UsuarioService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facturacion App',
      initialRoute: 'ckeckAuth',
      routes: {
        'ckeckAuth': (context) => const CheckAuthScreen(),
        'login': (context) => const LoginScreen(),
        'menu': (context) => const MenuScreen(),
        'user': (context) => const UserScreen(),
        'userform': (context) => const UserFormScreen(),
        'userinfo': (context) => const UserInfoScreen(),
        'invoice': (context) => const InvoiceScreen(),
        'invoiceform': (context) => FormInvoiceScreen(),
        'monitoring': (context) => const MonitoringScreen(),
        'district': (context) => const DistricScreen(),
        'purchase': (context) => const PurchaseScreen(),
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: AppTheme.lightTheme,
    );
  }
}
