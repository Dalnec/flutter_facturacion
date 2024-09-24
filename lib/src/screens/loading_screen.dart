import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text('Productos App'),
      // ),
      body: Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
        ),
      ),
    );
  }
}
