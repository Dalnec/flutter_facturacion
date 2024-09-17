import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compra de Agua'),
      ),
      body: const Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8.0),
            physics: ScrollPhysics(),
            child: Row(
              children: [
                _CardContainer(
                    child: SizedBox(
                  width: 340,
                  // width: double.infinity,
                  height: 250,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: LineChartExample(),
                  ),
                )),
              ],
            ),
          ),
          Text("data", style: TextStyle(color: AppTheme.primary, fontSize: 20)),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _CardContainer(
                child: SizedBox(
              width: double.infinity,
              child: PaginatedTableExample(),
            )),
          )),
        ],
      ),
    );
  }
}

class LineChartExample extends StatelessWidget {
  const LineChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      // AppTheme.tertiary,
      // AppTheme.primary,
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
          horizontalInterval: 1,
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
        titlesData: const FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
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
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0, // Valor mínimo del eje X
        maxX: 11, // Valor máximo del eje X
        minY: 0, // Valor mínimo del eje Y
        maxY: 6, // Valor máximo del eje Y
        lineBarsData: [
          LineChartBarData(
            // Cada punto del gráfico
            spots: [
              const FlSpot(0, 2),
              const FlSpot(0.5, 3),
              const FlSpot(1, 1),
              const FlSpot(2, 4),
              const FlSpot(3, 3),
              const FlSpot(4, 5),
              const FlSpot(5, 3),
              const FlSpot(6, 4),
              const FlSpot(7, 2),
              const FlSpot(8, 4),
              const FlSpot(9, 3),
              const FlSpot(10, 5),
              const FlSpot(11, 1),
            ],
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
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            // Color bajo la línea
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  ColorTween(begin: gradientColors[0], end: gradientColors[1])
                      .lerp(0.2)!
                      .withOpacity(0.1),
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

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Ene', style: style);
      break;
    case 1:
      text = const Text('Feb', style: style);
      break;
    case 2:
      text = const Text('Mar', style: style);
      break;
    case 3:
      text = const Text('Abr', style: style);
      break;
    case 4:
      text = const Text('May', style: style);
      break;
    case 5:
      text = const Text('Jun', style: style);
      break;
    case 6:
      text = const Text('Jul', style: style);
      break;
    case 7:
      text = const Text('Ago', style: style);
      break;
    case 8:
      text = const Text('Sep', style: style);
      break;
    case 9:
      text = const Text('Oct', style: style);
      break;
    case 10:
      text = const Text('Nov', style: style);
      break;
    case 11:
      text = const Text('Dec', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt()) {
    case 1:
      text = '10K';
      break;
    case 3:
      text = '30k';
      break;
    case 5:
      text = '50k';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}

class MyDataTableSource extends DataTableSource {
  // Lista de datos a mostrar en la tabla
  final List<Map<String, dynamic>> _data = List.generate(
    100,
    (index) => {
      'id': index + 1,
      'name': 'Nombre $index',
      'age': 20 + index % 10,
    },
  );

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;

    final item = _data[index];

    return DataRow(
      color: const WidgetStatePropertyAll(Colors.white),
      cells: [
        DataCell(Text(item['id'].toString())),
        DataCell(Text(item['name'])),
        DataCell(Text(item['name'])),
        DataCell(Text(item['name'])),
        DataCell(Text(item['age'].toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

class PaginatedTableExample extends StatelessWidget {
  const PaginatedTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        // header: const Text('Datos de Usuarios'),
        headingRowColor: const WidgetStatePropertyAll(AppTheme.primary),
        columns: const [
          DataColumn(label: Text('ID', style: TextStyle(color: AppTheme.harp))),
          DataColumn(
              label: Text('Nombre', style: TextStyle(color: AppTheme.harp))),
          DataColumn(
              label: Text('Nombre', style: TextStyle(color: AppTheme.harp))),
          DataColumn(
              label: Text('Nombre', style: TextStyle(color: AppTheme.harp))),
          DataColumn(
              label: Text('Edad', style: TextStyle(color: AppTheme.harp))),
        ],
        source: MyDataTableSource(),
        // Cantidad de filas por página
        rowsPerPage: 10,
        // Mostrar barra de acciones
        showCheckboxColumn: false,
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      padding: const EdgeInsets.all(8),
      decoration: _createCardShape(),
      child: child,
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
