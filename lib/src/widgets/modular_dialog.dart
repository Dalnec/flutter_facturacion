import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

class ModularDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const ModularDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title), // Título dinámico
      content: content, // Contenido dinámico
      actions: actions, // Acciones dinámicas (botones, etc.)
    );
  }

  // Método estático para mostrar el diálogo de manera modular
  static Future<void> showModularDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ModularDialog(
          title: title,
          content: content,
          actions: actions,
        );
      },
    );
  }
}
