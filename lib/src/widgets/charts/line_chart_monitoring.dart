import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LineChartMonitoring extends StatefulWidget {
  const LineChartMonitoring({super.key});

  @override
  State<LineChartMonitoring> createState() => _LineChartMonitoringState();
}

class _LineChartMonitoringState extends State<LineChartMonitoring> {
  var baselineX = 0.0;
  var baselineY = 0.0;
  // Variable para controlar el rango actual
  int currentRange = 1;
  // final TextEditingController _dateController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  bool _isLoading = false;
  List<Monitoring> _data = [];
  double maxValue = 100;

  @override
  void initState() {
    super.initState();
    // _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _selectedDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final invoiceService =
        Provider.of<MonitoringService>(context, listen: false);
    _data = await invoiceService.getMonitoringsNoPagination(
      "${_selectedDateRange?.start.toString().split(' ')[0]} 00:00:00",
      "${_selectedDateRange?.end.toString().split(' ')[0]} 23:59:59",
    );
    maxValue = double.parse('${_data.length}');
    print(maxValue);
    setState(() {
      _isLoading = false;
    });
  }

  // This function will be triggered when the floating button is pressed
  void _show() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(now.year, now.month, now.day),
      currentDate: now,
      saveText: 'Aplicar',
      initialEntryMode: DatePickerEntryMode.input,
      initialDateRange: _selectedDateRange,
    );

    if (result != null) {
      // Rebuild the UI
      print(result.start.toString());
      setState(() {
        _selectedDateRange = result;
        _fetchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(
              children: [
                Text(
                  "Desde: ",
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  "${_selectedDateRange?.start.toString().split(' ')[0]}",
                  style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.info,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Text("Hasta: ",
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.primary,
                    )),
                Text("${_selectedDateRange?.end.toString().split(' ')[0]}",
                    style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: _show,
              icon: const Icon(Icons.date_range, color: AppTheme.primary),
            ),
          ]),
          _CardContainer(
            height: 300,
            child: _isLoading
                ? Center(child: const CircularProgressIndicator())
                : _Chart(
                    baselineX,
                    (20 - (baselineY + 10)) - 10,
                    currentRange,
                    _data.reversed.toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  final double baselineX;
  final double baselineY;
  final int currentRange;
  final List<Monitoring> data;

  const _Chart(this.baselineX, this.baselineY, this.currentRange, this.data)
      : super();

  Widget getHorizontalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineX).abs() <= 0.1) {
      style = const TextStyle(
        color: AppTheme.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = TextStyle(
        color: AppTheme.primary.withOpacity(0.7),
        fontSize: 14,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text('${(value + (currentRange - 1) * 10).toStringAsFixed(0)}',
          style: style),
    );
  }

  Widget getVerticalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineY).abs() <= 0.1) {
      style = const TextStyle(
        color: AppTheme.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = TextStyle(
        color: AppTheme.primary.withOpacity(0.7),
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }

  FlLine getHorizontalVerticalLine(double value) {
    if ((value - baselineY).abs() <= 0.1) {
      return const FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return const FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  FlLine getVerticalVerticalLine(double value) {
    if ((value - baselineX).abs() <= 0.1) {
      return const FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return const FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('data: $data');
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(
                      // double.parse('${e.getMonth()}'),
                      double.parse('${e.key + 1}'),
                      double.parse(e.value.measured),
                    ))
                .toList(),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              // getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(
              '# lecturas diarias sensor',
              style: TextStyle(
                fontSize: 14,
                // color: mainLineColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            sideTitles: SideTitles(
                showTitles: true,
                // getTitlesWidget: getHorizontalTitles,
                reservedSize: 32),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          // getDrawingHorizontalLine: getHorizontalVerticalLine,
          // getDrawingVerticalLine: getVerticalVerticalLine,
        ),
        minY: 0,
        // maxY: 10,
        baselineY: baselineY,
        // minX: 0,
        // maxX: 10,
        baselineX: baselineX,
      ),
      duration: Duration.zero,
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  final double? height;

  const _CardContainer({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      // width: 300,
      height: height ?? null,
      decoration: _createCardShape(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      );
}
