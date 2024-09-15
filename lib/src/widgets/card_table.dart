import 'dart:ui';
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

class CardTable extends StatelessWidget {
  const CardTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: const [
        TableRow(children: [
          _SingleCard(
              color: AppTheme.primary, icon: Icons.border_all, text: 'Table 1'),
          _SingleCard(
              color: AppTheme.primary, icon: Icons.call_split, text: 'Table 2'),
        ]),
        TableRow(children: [
          _SingleCard(
              color: AppTheme.primary, icon: Icons.call_split, text: 'Table 3'),
          _SingleCard(
              color: AppTheme.primary, icon: Icons.border_all, text: 'Table 4'),
        ]),
        TableRow(children: [
          _SingleCard(
              color: AppTheme.primary, icon: Icons.call_split, text: 'Table 3'),
          _SingleCard(
              color: AppTheme.primary, icon: Icons.border_all, text: 'Table 4'),
        ]),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  const _SingleCard(
      {super.key, required this.color, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return _CardBackground(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 35,
          child: Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        )
      ],
    ));
  }
}

class _CardBackground extends StatelessWidget {
  final Widget child;
  const _CardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
