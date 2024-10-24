import 'dart:math';
import 'package:facturacion/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/services/services.dart' show InvoiceService;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class BarChartWidget extends StatefulWidget {
  final int? year;

  BarChartWidget({super.key, this.year});

  final Color dark = AppTheme.primary.withOpacity(0.9);
  final Color normal = AppTheme.primary.withOpacity(0.2);
  final Color light = AppTheme.harp;

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  bool _isLoading = false;
  final storage = const FlutterSecureStorage();
  String _profile = '';
  final int _pageSize = 12;
  List<Invoice> _data = [];
  int _year = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

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
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    _profile = await storage.read(key: 'profile') ?? '';
    final String usuarioId;
    usuarioId = await storage.read(key: 'usuario') ?? '';
    final invoiceService = Provider.of<InvoiceService>(context, listen: false);
    await invoiceService.getInvoicesResponse(
      usuarioId,
      widget.year,
      '-read_date',
      _pageSize,
      1,
    );
    final newData = invoiceService.invoices;
    _data = newData;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_year != widget.year && widget.year != null) {
      _year = widget.year!;
      _fetchData();
      _data.clear();
      setState(() {});
    }
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final barsSpace = 13.5 * constraints.maxWidth / 400;
                  final barsWidth = 18.0 * constraints.maxWidth / 400;
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => Colors.transparent,
                            tooltipPadding: EdgeInsets.zero,
                            tooltipMargin: -2,
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
                      barGroups: _data.reversed
                          .map(
                            (data) => makeGroupData(
                              data.getMonth(),
                              double.tryParse(data.measured) ?? 0,
                              width: barsWidth,
                            ),
                          )
                          .toList(),
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
    double width = 0,
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
