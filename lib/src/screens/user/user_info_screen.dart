import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart'
    show BarChartWidget, PaginatedDataTableWidget;

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> datos = List.generate(
      100,
      (index) => {
        'id': index + 1,
        'name': 'Nombre $index',
        'age': 20 + index % 10,
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Usuario'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 5),
          const Text(
              textAlign: TextAlign.center,
              "Ultimos Pagos:",
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 20,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _CardContainer(
              height: 230,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                // child: LineChartExample(),
                child: BarChartWidget(),
              ),
            ),
          ),
          const Text(
              textAlign: TextAlign.center,
              "Lista de Recibos:",
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 20,
              )),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: _CardContainer(
          //       child: PaginatedDataTableWidget(
          //     source: _MyDataTableSource(datos),
          //     headingRowColor: AppTheme.primary,
          //     columns: _columnsDataTable(),
          //   )),
          // ),
        ],
      ),
    );
  }
}

// ChartInfo
List<FlSpot> _getSpots() => [
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
    ];

Widget _bottomTitleWidgets(double value, TitleMeta meta) {
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

Widget _leftTitleWidgets(double value, TitleMeta meta) {
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

// DataTableInfo
class _MyDataTableSource extends DataTableSource {
  // Lista de datos a mostrar en la tabla
  final List<Map<String, dynamic>> _data;

  _MyDataTableSource(this._data);

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

List<DataColumn> _columnsDataTable() {
  return [
    const DataColumn(label: Text('ID', style: TextStyle(color: AppTheme.harp))),
    const DataColumn(
        label: Text('Nombre', style: TextStyle(color: AppTheme.harp))),
    const DataColumn(
        label: Text('Nombre', style: TextStyle(color: AppTheme.harp))),
    const DataColumn(
        label: Text('Nombre', style: TextStyle(color: AppTheme.harp))),
    const DataColumn(
        label: Text('Edad', style: TextStyle(color: AppTheme.harp))),
  ];
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  final double? height;

  const _CardContainer({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      padding: const EdgeInsets.all(8),
      // width: 300,
      height: height ?? null,
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
