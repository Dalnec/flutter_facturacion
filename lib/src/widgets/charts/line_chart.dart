import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final List<FlSpot> spots;
  final Widget Function(double, TitleMeta) bottomTitleWidgets;
  final Widget Function(double, TitleMeta) leftTitleWidgets;

  const LineChartWidget({
    super.key,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.spots,
    required this.bottomTitleWidgets,
    required this.leftTitleWidgets,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Colors.blue,
      Colors.blue.withOpacity(0.2),
    ];
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.grey.withOpacity(0.5),
          ),
        ),
        // Mostrar cuadrícula
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          verticalInterval: 1,
          horizontalInterval: 0.1,
          // checkToShowHorizontalLine: (value) => value % 5 == 0,
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Color(0xff37434d),
              strokeWidth: 0.5,
            );
          },
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xff37434d),
              strokeWidth: 0.5,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.5,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: minX, // Valor mínimo del eje X
        // maxX: maxX, // Valor máximo del eje X
        minY: minY, // Valor mínimo del eje Y
        // maxY: maxY, // Valor máximo del eje Y
        lineBarsData: [
          LineChartBarData(
            // Cada punto del gráfico
            spots: spots,
            isCurved: false,
            // Color de la línea
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!,
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!,
              ],
            ),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            // Color bajo la línea
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  ColorTween(begin: gradientColors[0], end: gradientColors[1])
                      .lerp(0.2)!
                      .withOpacity(0.2),
                  ColorTween(begin: gradientColors[0], end: gradientColors[1])
                      .lerp(0.2)!
                      .withOpacity(0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget bottomTitleWidgets(double value, TitleMeta meta) {
//   const style = TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 14,
//   );
//   Widget text;
//   switch (value.toInt()) {
//     case 0:
//       text = const Text('Ene', style: style);
//       break;
//     case 1:
//       text = const Text('Feb', style: style);
//       break;
//     case 2:
//       text = const Text('Mar', style: style);
//       break;
//     case 3:
//       text = const Text('Abr', style: style);
//       break;
//     case 4:
//       text = const Text('May', style: style);
//       break;
//     case 5:
//       text = const Text('Jun', style: style);
//       break;
//     case 6:
//       text = const Text('Jul', style: style);
//       break;
//     case 7:
//       text = const Text('Ago', style: style);
//       break;
//     case 8:
//       text = const Text('Sep', style: style);
//       break;
//     case 9:
//       text = const Text('Oct', style: style);
//       break;
//     case 10:
//       text = const Text('Nov', style: style);
//       break;
//     case 11:
//       text = const Text('Dec', style: style);
//       break;
//     default:
//       text = const Text('', style: style);
//       break;
//   }

//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     child: text,
//   );
// }

// Widget leftTitleWidgets(double value, TitleMeta meta) {
//   const style = TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 14,
//   );
//   String text;
//   switch (value.toInt()) {
//     case 1:
//       text = '10K';
//       break;
//     case 3:
//       text = '30k';
//       break;
//     case 5:
//       text = '50k';
//       break;
//     default:
//       return Container();
//   }

//   return Text(text, style: style, textAlign: TextAlign.left);
// }
