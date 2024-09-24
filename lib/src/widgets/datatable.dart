import 'package:facturacion/src/services/services.dart';
import 'package:flutter/material.dart';

class PaginatedDataTableWidget extends StatelessWidget {
  final DataTableSource source;
  final MonitoringService monitoringService;
  final Color headingRowColor;
  final List<DataColumn> columns;

  const PaginatedDataTableWidget({
    super.key,
    required this.source,
    required this.headingRowColor,
    required this.columns,
    required this.monitoringService,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: PaginatedDataTable(
      // header: const Text('Lista'),
      headingRowColor: WidgetStatePropertyAll(headingRowColor),
      headingRowHeight: 38,
      columns: columns,
      source: source,
      // Cantidad de filas por página
      rowsPerPage: 10,
      onPageChanged: (pageIndex) {
        monitoringService.getMonitoringsResponse('', 10, pageIndex);
      },
      // Mostrar barra de acciones
      showCheckboxColumn: false,
    ));
  }
}
