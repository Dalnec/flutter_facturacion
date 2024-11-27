import 'dart:async';
import 'dart:math';
import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterTankLevel extends StatefulWidget {
  const WaterTankLevel({super.key});

  @override
  _WaterTankLevelState createState() => _WaterTankLevelState();
}

class _WaterTankLevelState extends State<WaterTankLevel>
    with SingleTickerProviderStateMixin {
  final List<double> waterLevels = [0.1, 0.5, 0.8, 0.3, 0.7, 1.0, 0.4];
  int initCount = 0;
  bool initLoading = false;
  double currentWaterLevel = 0.0;
  late Timer _timer;
  late AnimationController _waveController;
  bool _isLoading = false;
  Monitoring _dataCard = Monitoring(
    readDate: '',
    measured: '',
    status: '',
    percentage: '',
    isConnected: false,
    battery: '',
    height: '',
  );

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // Repetir la animación
    _fetchData();
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
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _fetchData();
      // setState(() {
      // currentWaterLevel = waterLevels[currentIndex];
      // currentIndex = (currentIndex + 1) % waterLevels.length;
      // });
      // currentWaterLevel = double.parse(_dataCard.percentage) / 100;
      // setState(() {});
      // print(currentWaterLevel);
    });
  }

  Future<void> _fetchData() async {
    setState(() {
      if (initCount == 0) {
        initLoading = true;
        initCount++;
      }
      _isLoading = true;
    });
    final monitoringService =
        Provider.of<MonitoringService>(context, listen: false);
    await monitoringService.getLastReading();
    _dataCard = monitoringService.lastMonitoring;
    currentWaterLevel = double.parse(_dataCard.percentage) / 100;
    _isLoading = false;
    initLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Capacidad: ${(_dataCard.capacity ?? 0.0).toInt()} litros",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  )),
              Text("Altura: ${_dataCard.height} cm",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  )),
            ],
          ),
          Row(
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
                      height: 170,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 3),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(10),
                            top: Radius.circular(5)),
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
                                        painter: WavePainter(
                                            _waveController.value,
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_dataCard.liters} litros aprox.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              initLoading
                  ? Center(child: CircularProgressIndicator())
                  : InfoDisplay(
                      currentWaterLevel: _dataCard.percentage,
                      lastUpdate: _dataCard.readDate,
                      isConnected: _dataCard.isConnected ?? false,
                      batteryLevel: _dataCard.battery,
                      measured: _dataCard.measured,
                      liters: _dataCard.liters ?? 0,
                      height: _dataCard.height ?? '',
                      capacity: _dataCard.capacity ?? 0,
                    )
            ],
          ),
        ],
      ),
    );
  }
}

class InfoDisplay extends StatelessWidget {
  final String currentWaterLevel;
  final String lastUpdate;
  final bool isConnected;
  final String batteryLevel;
  final String measured;
  final double liters;
  final String height;
  final double capacity;

  const InfoDisplay({
    super.key,
    required this.currentWaterLevel,
    required this.lastUpdate,
    required this.isConnected,
    required this.batteryLevel,
    required this.liters,
    required this.height,
    required this.capacity,
    required this.measured,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
            icon: Icons.water_drop_outlined,
            color: Colors.blue,
            label: 'Nivel de Agua',
            value:
                '$currentWaterLevel% ${double.parse(height) - double.parse(measured)} cm',
          ),
          const SizedBox(height: 10),
          // Última Actualización
          _InfoDetail(
            icon: Icons.update,
            color: Colors.orange,
            label: 'Última Actualización',
            value: lastUpdate,
          ),
          const SizedBox(height: 10),
          // Estado del Dispositivo
          if (isConnected)
            _InfoDetail(
              icon: Icons.wifi,
              color: Colors.green,
              label: 'Estado Dispositivo',
              value: 'CONECTADO',
              textColor: Colors.green,
            )
          else
            _InfoDetail(
              icon: Icons.wifi_off,
              color: Colors.red,
              label: 'Estado Dispositivo',
              value: 'DESCONECTADO',
              textColor: Colors.red,
            ),
          const SizedBox(height: 10),
          isConnected
              ? _batteryLevelInfo(batteryLevel)
              : _InfoDetail(
                  icon: Icons.battery_unknown_outlined,
                  color: Colors.red,
                  label: 'Nivel Bateria',
                  value: '-',
                  textColor: Colors.red,
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
        const SizedBox(width: 5),
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

Widget _batteryLevelInfo(String batteryLevel) {
  IconData batteryIcon = Icons.battery_0_bar_outlined;
  Color batteryColor = Colors.red;
  int batteryLevelInt = batteryLevel.isEmpty ? 0 : int.parse(batteryLevel);
  if (batteryLevelInt == 100) {
    batteryIcon = Icons.battery_charging_full_outlined;
    batteryColor = Colors.green;
  }
  if (batteryLevelInt < 100 && batteryLevelInt > 95) {
    batteryIcon = Icons.battery_6_bar_outlined;
    batteryColor = Colors.green;
  }
  if (batteryLevelInt <= 95 && batteryLevelInt > 75) {
    batteryIcon = Icons.battery_6_bar_outlined;
    batteryColor = Colors.green.shade400;
  }
  if (batteryLevelInt <= 75 && batteryLevelInt > 60) {
    batteryIcon = Icons.battery_5_bar_outlined;
    batteryColor = Colors.green.shade600;
  }
  if (batteryLevelInt <= 60 && batteryLevelInt > 50) {
    batteryIcon = Icons.battery_3_bar_outlined;
    batteryColor = Colors.green.shade800;
  }
  if (batteryLevelInt <= 50 && batteryLevelInt > 25) {
    batteryIcon = Icons.battery_2_bar_outlined;
    batteryColor = Colors.orange.shade700;
  }
  if (batteryLevelInt <= 25 && batteryLevelInt >= 0) {
    batteryIcon = Icons.battery_0_bar_outlined;
    batteryColor = Colors.red.shade400;
  }

  return _InfoDetail(
    icon: batteryIcon,
    color: batteryColor,
    label: 'Nivel Bateria',
    value: '$batteryLevel%',
    textColor: batteryColor,
  );
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
