import 'dart:ui';
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

class CardTable extends StatelessWidget {
  const CardTable({super.key});

  @override
  Widget build(BuildContext context) {
    // return Table(
    //   children: const [
    //     TableRow(children: [
    //       _SingleCard(
    //         color: AppTheme.secondary,
    //         icon: Icons.people_alt_outlined,
    //         text: 'Usuario',
    //         route: 'user',
    //       ),
    //       _SingleCard(
    //         color: AppTheme.secondary,
    //         icon: Icons.add_chart_outlined,
    //         text: 'Facturar',
    //         route: 'invoice',
    //       ),
    //     ]),
    //     TableRow(children: [
    //       _SingleCard(
    //         color: AppTheme.secondary,
    //         icon: Icons.monitor_heart_outlined,
    //         text: 'Monitoreo',
    //         route: 'monitoring',
    //       ),
    //       _SingleCard(
    //         color: AppTheme.secondary,
    //         icon: Icons.water_damage_outlined,
    //         // text: 'Compras',
    //         text: 'Tarifas',
    //         route: 'purchase',
    //       ),
    //     ]),
    //     TableRow(children: [
    //       _SingleCard(
    //         color: AppTheme.secondary,
    //         icon: Icons.house_outlined,
    //         text: 'Barrio',
    //         route: 'district',
    //       ),
    //       _SingleCard(
    //         color: AppTheme.secondary,
    //         icon: Icons.perm_contact_cal_outlined,
    //         text: 'Empleados',
    //         route: 'employee',
    //       ),
    //     ]),
    //   ],
    // );
    final menu = [
      _SingleCard(
        color: AppTheme.secondary,
        icon: Icons.people_alt_outlined,
        text: 'Usuario',
        route: 'user',
      ),
      _SingleCard(
        color: AppTheme.secondary,
        icon: Icons.add_chart_outlined,
        text: 'Facturar',
        route: 'invoice',
      ),
      _SingleCard(
        color: AppTheme.secondary,
        icon: Icons.monitor_heart_outlined,
        text: 'Monitoreo',
        route: 'monitoring',
      ),
      _SingleCard(
        color: AppTheme.secondary,
        icon: Icons.water_damage_outlined,
        text: 'Tarifas',
        route: 'purchase',
      ),
      _SingleCard(
        color: AppTheme.secondary,
        icon: Icons.house_outlined,
        text: 'Barrio',
        route: 'district',
      ),
      _SingleCard(
        color: AppTheme.secondary,
        icon: Icons.perm_contact_cal_outlined,
        text: 'Encargados',
        route: 'employee',
      ),
      _SingleCard(
        color: AppTheme.secondary,
        icon: Icons.picture_as_pdf_outlined,
        text: 'Reportes',
        route: 'report',
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true, // Allows GridView to take only the space it needs
      physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling
      children: menu,
    );
  }
}

class _SingleCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final String route;
  const _SingleCard({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return _CardBackground(
        route: route,
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
              text,
              // text.toUpperCase(),
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
  final String route;
  const _CardBackground({super.key, required this.child, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(5.0, 5.0),
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
      ),
    );
  }
}
