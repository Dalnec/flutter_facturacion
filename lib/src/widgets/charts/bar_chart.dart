import 'package:facturacion/src/themes/theme.dart';
// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class BarChartWidget extends StatefulWidget {
  BarChartWidget({super.key});

  final Color dark = AppTheme.primary
      .withOpacity(0.9); /* AppColors.contentColorCyan.darken(60); */
  final Color normal = AppTheme.primary
      .withOpacity(0.2); /* AppColors.contentColorCyan.darken(30); */
  final Color light = AppTheme.harp; /* AppColors.contentColorCyan; */

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Ene';
      case 1:
        text = 'Feb';
      case 2:
        text = 'Mar';
      case 3:
        text = 'Abr';
      case 4:
        text = 'May';
      case 5:
        text = 'Jun';
      case 6:
        text = 'Jul';
      case 7:
        text = 'Ago';
      case 8:
        text = 'Sep';
      case 9:
        text = 'Oct';
      case 10:
        text = 'Nov';
      case 11:
        text = 'Dec';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 8.0 * constraints.maxWidth / 400;
            final barsWidth = 10.0 * constraints.maxWidth / 400;
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.transparent,
                      tooltipPadding: EdgeInsets.zero,
                      tooltipMargin: 2,
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          const TextStyle(
                            fontSize: 10,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    )),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 5 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppTheme.primary.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                // barGroups: getData(barsWidth, barsSpace),
                barGroups: List.generate(12, (i) {
                  switch (i) {
                    case 0:
                      return makeGroupData(
                        0,
                        Random().nextInt(15).toDouble() + 6,
                        width: barsWidth,
                      );
                    case 1:
                      return makeGroupData(
                        1,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 2:
                      return makeGroupData(
                        2,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 3:
                      return makeGroupData(
                        3,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 4:
                      return makeGroupData(
                        4,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 5:
                      return makeGroupData(
                        5,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 6:
                      return makeGroupData(
                        6,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 7:
                      return makeGroupData(
                        7,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 8:
                      return makeGroupData(
                        8,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 9:
                      return makeGroupData(
                        9,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 10:
                      return makeGroupData(
                        10,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    case 11:
                      return makeGroupData(
                        11,
                        Random().nextInt(15).toDouble() + 20,
                        width: barsWidth,
                      );
                    default:
                      return throw Error();
                  }
                }),
                // gridData: const FlGridData(show: false),
              ),
            );
          },
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = true,
    Color? barColor,
    double width = 18,
    List<int> showTooltips = const [0],
  }) {
    barColor ??= AppTheme.primary.withOpacity(0.5);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppTheme.tertiary.withOpacity(0.8),
          width: width,
          borderSide: const BorderSide(color: Colors.white, width: 0),
          borderRadius: BorderRadius.zero,
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
