import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// class WaterTankLevel extends StatefulWidget {
//   const WaterTankLevel({super.key});

//   @override
//   _WaterTankLevelState createState() => _WaterTankLevelState();
// }

// class _WaterTankLevelState extends State<WaterTankLevel> {
//   final List<double> waterLevels = [
//     0.1,
//     0.5,
//     0.8,
//     0.3,
//     0.7,
//     1.0,
//     0.4
//   ]; // Lista de valores de nivel de agua (0.0 a 1.0)
//   int currentIndex = 0;
//   double currentWaterLevel = 0.0;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startWaterLevelSimulation();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   // Función para simular el cambio de nivel de agua
//   void _startWaterLevelSimulation() {
//     _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       setState(() {
//         currentWaterLevel = waterLevels[currentIndex];
//         currentIndex = (currentIndex + 1) % waterLevels.length;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Monitoreo Tanque de Agua')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             // Contenedor para el tanque de agua
//             Container(
//               width: 170,
//               height: 230,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blueAccent, width: 3),
//                 borderRadius: const BorderRadius.vertical(
//                     bottom: Radius.circular(10), top: Radius.circular(5)),
//               ),
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   // Nivel de agua dentro del tanque
//                   AnimatedContainer(
//                     // Duración de la animación
//                     duration: const Duration(seconds: 1),
//                     width: double.infinity,
//                     // Ajusta la altura según el nivel actual de agua
//                     height: 300 * currentWaterLevel,
//                     decoration: const BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Nivel de agua: ${(currentWaterLevel * 100).toStringAsFixed(0)}%',
//               style: const TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class WaterTankLevel extends StatefulWidget {
  const WaterTankLevel({super.key});

  @override
  _WaterTankLevelState createState() => _WaterTankLevelState();
}

class _WaterTankLevelState extends State<WaterTankLevel>
    with SingleTickerProviderStateMixin {
  final List<double> waterLevels = [0.1, 0.5, 0.8, 0.3, 0.7, 1.0, 0.4];
  int currentIndex = 0;
  double currentWaterLevel = 0.0;
  late Timer _timer;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Repetir la animación de las olas indefinidamente
    _startWaterLevelSimulation();
  }

  @override
  void dispose() {
    _timer.cancel();
    _waveController.dispose();
    super.dispose();
  }

  // Simulación de cambio de nivel de agua
  void _startWaterLevelSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentWaterLevel = waterLevels[currentIndex];
        currentIndex = (currentIndex + 1) % waterLevels.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Contenedor del tanque de agua
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 3),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10), top: Radius.circular(5)),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${(currentWaterLevel * 100).toInt()}%',
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Nivel de agua con movimiento de olas
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: double.infinity,
                        height: 180 * currentWaterLevel,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.blueAccent.withOpacity(0.6),
                            ),
                            // Olas en la parte superior del agua
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: AnimatedBuilder(
                                animation: _waveController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: WavePainter(_waveController.value,
                                        currentWaterLevel),
                                    size: const Size(double.infinity, 50),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Tanque Barrial',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          InfoDisplay(currentWaterLevel: currentWaterLevel * 100)
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       'Nivel de Agua: ${(currentWaterLevel * 100).toStringAsFixed(0)}%',
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const Text(
          //       'Última Actualización: 15-09-2024 22:17',
          //       style: TextStyle(fontSize: 20),
          //     ),
          //     const Text(
          //       'Estado Dispositivo: CONECTADO',
          //       style: TextStyle(fontSize: 20),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class InfoDisplay extends StatelessWidget {
  final double currentWaterLevel;

  const InfoDisplay({super.key, required this.currentWaterLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nivel de Agua
          _InfoDetail(
              // icon: Icons.water,
              icon: Icons.water_drop_outlined,
              color: Colors.blue,
              label: 'Nivel de Agua',
              value: '$currentWaterLevel%'),
          const SizedBox(height: 15),
          // Última Actualización
          _InfoDetail(
            icon: Icons.update,
            color: Colors.orange,
            label: 'Última\nActualización',
            value: '15-09-2024 22:17',
          ),
          const SizedBox(height: 15),
          // Estado del Dispositivo
          _InfoDetail(
            icon: Icons.wifi,
            color: Colors.green,
            label: 'Estado Dispositivo',
            value: 'CONECTADO',
            textColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _InfoDetail extends StatelessWidget {
  IconData icon;
  Color color;
  Color? textColor;
  String label;
  String value;

  _InfoDetail({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double currentWaterLevel;

  WavePainter(this.animationValue, this.currentWaterLevel);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final path = Path();

    double waveHeight = 10.0; // Altura de las olas
    double waveLength = size.width; // Longitud de las olas

    // Dibujar la curva senoidal (ondas)
    for (double i = 0; i <= size.width; i++) {
      double y = sin((i / waveLength * 3 * pi) + (animationValue * 2 * pi)) *
              waveHeight +
          waveHeight;
      if (i == 0) {
        path.moveTo(i, y);
      } else {
        path.lineTo(i, y);
      }
    }
    // Línea hasta el borde inferior derecho
    path.lineTo(size.width, currentWaterLevel);
    // Línea hasta el borde inferior izquierdo
    path.lineTo(0, currentWaterLevel);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return true; // Re-dibujar las olas con cada cambio de valor en la animación
  }
}
