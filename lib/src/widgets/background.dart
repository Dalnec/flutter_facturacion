import 'dart:math';

import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.8],
          colors: [AppTheme.primary, AppTheme.secondary]));

  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _BackgroundBox(),
        // Purple gradient
        // Container(
        //   decoration: boxDecoration,
        // ),
        // Pink box
        // const Positioned(top: -100, left: -30, child: _PinkBox()),
        // const Positioned(top: -50, left: -30, child: _Drop()),
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  const _PinkBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(236, 98, 188, 1),
              Color.fromRGBO(241, 142, 172, 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _Drop extends StatelessWidget {
  const _Drop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 660,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(80),
      //   gradient: const LinearGradient(
      //     colors: [
      //       Color.fromRGBO(236, 98, 188, 1),
      //       Color.fromRGBO(241, 142, 172, 1),
      //     ],
      //   ),
      // ),
      child: Icon(Icons.water_drop, color: Colors.grey[400], size: 600),
    );
  }
}

class _BackgroundBox extends StatelessWidget {
  const _BackgroundBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: size.height,
        decoration: _purpleBackground(),
        child: Stack(
          children: List.generate(
            8, // Número de burbujas a generar
            (index) => _generateDropPositions(size),
          ),
        ));
  }

  Positioned _generateDropPositions(Size size) {
    // Crear una instancia de Random
    final random = Random();

    // Generar posiciones aleatorias para top y left dentro del tamaño de la pantalla
    final double top = random.nextDouble() * size.height;
    final double left = random.nextDouble() * size.width;

    return Positioned(
      top: top,
      left: left,
      child: const _Bubble(), // El widget de la burbuja
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary,
            AppTheme.secondary,
          ],
        ),
      );
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
      child: Icon(Icons.water_drop,
          color: Colors.white.withOpacity(0.1), size: 100),
    );
  }
}
