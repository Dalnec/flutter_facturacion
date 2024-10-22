import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:provider/provider.dart';

class InfiniteScrollDataTable extends StatefulWidget {
  const InfiniteScrollDataTable({Key? key}) : super(key: key);

  @override
  _InfiniteScrollDataTableState createState() =>
      _InfiniteScrollDataTableState();
}

class _InfiniteScrollDataTableState extends State<InfiniteScrollDataTable> {
  int _currentPage = 1; // Página actual
  final int _pageSize = 10; // Tamaño de página
  bool _isLoading = false; // Indicador de carga
  bool _hasMoreData = true; // Verificar si hay más datos para cargar
  final List<Monitoring> _data = []; // Lista de datos cargados

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Escuchar el scroll para cargar más datos cuando se acerque al final
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMoreData) {
        _loadMoreData();
      }
    });
    // Cargar la primera página de datos
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final monitoringService =
        Provider.of<MonitoringService>(context, listen: false);

    // Llamar a la API para obtener la página actual de datos
    await monitoringService.getMonitorings('', _pageSize, _currentPage);

    // final newData = monitoringService.response.results;
    final newData = monitoringService.monitorings;

    if (newData.isEmpty) {
      // No hay más datos por cargar
      _hasMoreData = false;
    } else {
      setState(() {
        // Agregar los nuevos datos a la lista existente
        _data.addAll(newData);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Cargar más datos cuando se llegue al final
  void _loadMoreData() {
    if (!_isLoading && _hasMoreData) {
      setState(() {
        _currentPage++; // Incrementar la página actual
      });
      _fetchData(); // Llamar a la API para cargar más datos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _data.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowHeight: 35,
                      columnSpacing: 30,
                      columns: const [
                        DataColumn(
                            label: Text('Fecha'),
                            headingRowAlignment: MainAxisAlignment.center),
                        DataColumn(
                            label: Text('Medición'),
                            headingRowAlignment: MainAxisAlignment.center),
                        DataColumn(
                            label: Text('Porcentaje'),
                            headingRowAlignment: MainAxisAlignment.center),
                      ],
                      rows: _data
                          .map((item) => DataRow(cells: [
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.readDate,
                                  ),
                                )),
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.measured,
                                  ),
                                )),
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.percentage.toString(),
                                  ),
                                )),
                              ]))
                          .toList(),
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
    );
  }
}
