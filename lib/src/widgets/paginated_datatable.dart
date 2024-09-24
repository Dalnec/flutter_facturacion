// import 'package:facturacion/src/models/models.dart';
// import 'package:facturacion/src/services/services.dart';
// import 'package:facturacion/src/themes/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PaginatedDataTableView extends StatefulWidget {
//   const PaginatedDataTableView({super.key});

//   @override
//   State<PaginatedDataTableView> createState() => _PaginatedDataTableViewState();
// }

// class _PaginatedDataTableViewState extends State<PaginatedDataTableView> {
//   int _currentPage = 1;
//   int _pageSize = 10;
//   int _count = 0;
//   List<Monitoring> _data = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//     final monitoringService =
//         Provider.of<MonitoringService>(context, listen: false);

//     await monitoringService.getMonitorings('', _pageSize, _currentPage);

//     // _data.addAll(monitoringService.response.results);
//     _data = [..._data, ...monitoringService.response.results];
//     // _data = monitoringService.response.results;
//     _count = monitoringService.response.count;
//     _isLoading = false;
//     setState(() {});

//     @override
//     Widget build(BuildContext context) {
//       // TODO: implement build
//       throw UnimplementedError();
//     }
//   }

//   void _loadMoreData(int pageIndex) {
//     if (!_isLoading) {
//       setState(() {
//         // _currentPage++;
//         // Actualiza la página actual basándote en la nueva página calculada
//         _currentPage = (pageIndex ~/ _pageSize) + 1;
//       });
//       fetchData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : SingleChildScrollView(
//             child: SizedBox(
//               width: double.infinity,
//               child: PaginatedDataTable(
//                 // header: const Text('Data Table Header'),
//                 rowsPerPage: _pageSize,
//                 availableRowsPerPage: const [10, 25, 50],
//                 onRowsPerPageChanged: (value) {
//                   setState(() {
//                     _pageSize = value!;
//                     // Reinicia la página cuando cambie el tamaño de la página
//                     _currentPage = 1;
//                   });
//                   fetchData();
//                 },
//                 onPageChanged: (pageIndex) {
//                   print('pageIndex $pageIndex');
//                   _loadMoreData(pageIndex);
//                 },
//                 columns: const [
//                   DataColumn(
//                       label: Text('ID',
//                           style: TextStyle(color: AppTheme.primary))),
//                   DataColumn(
//                       label: Text('Fecha',
//                           style: TextStyle(color: AppTheme.primary))),
//                   DataColumn(
//                       label: Text('Medición',
//                           style: TextStyle(color: AppTheme.primary))),
//                   DataColumn(
//                       label: Text('Estado',
//                           style: TextStyle(color: AppTheme.primary))),
//                 ],
//                 source: _DataSource(data: _data, count: _count),
//                 // dataRowMinHeight: 15,
//                 // dataRowMaxHeight: 40,
//                 // columnSpacing: 30,
//                 showFirstLastButtons: true,
//                 headingRowHeight: 35,
//               ),
//             ),
//           );
//   }
// }

// class _DataSource extends DataTableSource {
//   final List<Monitoring> data;
//   final int count;
//   _DataSource({required this.data, required this.count});

//   @override
//   DataRow? getRow(int index) {
//     print("data ${data.length}");
//     if (index >= count) {
//       return null;
//     }

//     final item = data[index];

//     return DataRow(cells: [
//       DataCell(Text(item.id.toString())),
//       DataCell(Text(item.readDate)),
//       DataCell(Text(item.measured)),
//       DataCell(Text(item.status)),
//     ]);
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => count;

//   @override
//   int get selectedRowCount => 0;
// }

// import 'package:flutter/material.dart';
// import 'package:facturacion/src/models/models.dart';
// import 'package:facturacion/src/services/services.dart';
// import 'package:provider/provider.dart';

// class InfiniteScrollDataTable extends StatefulWidget {
//   const InfiniteScrollDataTable({Key? key}) : super(key: key);

//   @override
//   _InfiniteScrollDataTableState createState() =>
//       _InfiniteScrollDataTableState();
// }

// class _InfiniteScrollDataTableState extends State<InfiniteScrollDataTable> {
//   int _currentPage = 1; // Página actual
//   final int _pageSize = 10; // Tamaño de página
//   bool _isLoading = false; // Indicador de carga
//   bool _hasMoreData = true; // Verificar si hay más datos para cargar
//   List<Monitoring> _data = []; // Lista de datos cargados

//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     // Escuchar el scroll para cargar más datos cuando se acerque al final
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//               _scrollController.position.maxScrollExtent &&
//           _hasMoreData) {
//         _loadMoreData();
//       }
//     });
//     // Cargar la primera página de datos
//     _fetchData();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final monitoringService =
//         Provider.of<MonitoringService>(context, listen: false);

//     // Llamar a la API para obtener la página actual de datos
//     await monitoringService.getMonitorings('', _pageSize, _currentPage);

//     final newData = monitoringService.response.results;

//     if (newData.isEmpty) {
//       _hasMoreData = false; // No hay más datos por cargar
//     } else {
//       setState(() {
//         _data.addAll(newData); // Agregar los nuevos datos a la lista existente
//       });
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   // Cargar más datos cuando se llegue al final
//   void _loadMoreData() {
//     if (!_isLoading && _hasMoreData) {
//       setState(() {
//         _currentPage++; // Incrementar la página actual
//       });
//       _fetchData(); // Llamar a la API para cargar más datos
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Infinite Scroll DataTable'),
//       // ),
//       body: _data.isEmpty && _isLoading
//           ? const Center(
//               child:
//                   CircularProgressIndicator()) // Mostrar un indicador de carga inicial
//           : ListView.builder(
//               controller: _scrollController,
//               itemCount: _data.length + (_hasMoreData ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == _data.length) {
//                   // Mostrar un indicador de carga mientras se cargan más datos
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     child: Center(child: CircularProgressIndicator()),
//                   );
//                 }

//                 final item = _data[index];

//                 // Mostrar las filas de la tabla con los datos cargados
//                 return DataTable(
//                   columns: const [
//                     DataColumn(label: Text('ID')),
//                     DataColumn(label: Text('Fecha')),
//                     DataColumn(label: Text('Medición')),
//                     DataColumn(label: Text('Estado')),
//                   ],
//                   rows: [
//                     DataRow(cells: [
//                       DataCell(Text(item.id.toString())),
//                       DataCell(Text(item.readDate)),
//                       DataCell(Text(item.measured)),
//                       DataCell(Text(item.status)),
//                     ])
//                   ],
//                 );
//               },
//             ),
//     );
//   }
// }

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
  List<Monitoring> _data = []; // Lista de datos cargados

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

    final newData = monitoringService.response.results;

    if (newData.isEmpty) {
      _hasMoreData = false; // No hay más datos por cargar
    } else {
      setState(() {
        _data.addAll(newData); // Agregar los nuevos datos a la lista existente
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
      // appBar: AppBar(
      //   title: const Text('Infinite Scroll DataTable'),
      // ),
      body: _data.isEmpty && _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Mostrar un indicador de carga inicial
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  DataTable(
                    headingRowHeight: 35,
                    columnSpacing: 30,
                    columns: const [
                      DataColumn(label: Text('Cod')),
                      DataColumn(
                          label: Text('Fecha'),
                          headingRowAlignment: MainAxisAlignment.center),
                      DataColumn(
                          label: Text('Medición'),
                          headingRowAlignment: MainAxisAlignment.center),
                      DataColumn(
                          label: Text('Estado'),
                          headingRowAlignment: MainAxisAlignment.center),
                    ],
                    rows: _data
                        .map((item) => DataRow(cells: [
                              DataCell(Text(
                                item.id.toString(),
                                textAlign: TextAlign.center,
                              )),
                              DataCell(Text(
                                item.readDate,
                                textAlign: TextAlign.center,
                              )),
                              DataCell(Text(
                                item.measured,
                                textAlign: TextAlign.center,
                              )),
                              DataCell(Text(
                                item.status,
                                textAlign: TextAlign.center,
                              )),
                            ]))
                        .toList(),
                  ),
                  if (_isLoading) // Indicador de carga mientras se cargan más datos
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

// import 'package:flutter/material.dart';
// import 'package:facturacion/src/models/models.dart';
// import 'package:facturacion/src/services/services.dart';
// import 'package:provider/provider.dart';

// class StickyHeaderDataTable extends StatefulWidget {
//   const StickyHeaderDataTable({Key? key}) : super(key: key);

//   @override
//   _StickyHeaderDataTableState createState() => _StickyHeaderDataTableState();
// }

// class _StickyHeaderDataTableState extends State<StickyHeaderDataTable> {
//   int _currentPage = 1;
//   final int _pageSize = 10;
//   bool _isLoading = false;
//   bool _hasMoreData = true;
//   List<Monitoring> _data = [];

//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//               _scrollController.position.maxScrollExtent &&
//           _hasMoreData) {
//         _loadMoreData();
//       }
//     });
//     _fetchData();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final monitoringService =
//         Provider.of<MonitoringService>(context, listen: false);

//     await monitoringService.getMonitorings('', _pageSize, _currentPage);

//     final newData = monitoringService.response.results;

//     if (newData.isEmpty) {
//       _hasMoreData = false;
//     } else {
//       setState(() {
//         _data.addAll(newData);
//       });
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _loadMoreData() {
//     if (!_isLoading && _hasMoreData) {
//       setState(() {
//         _currentPage++;
//       });
//       _fetchData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sticky Header DataTable'),
//       ),
//       body: _data.isEmpty && _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : CustomScrollView(
//               controller: _scrollController,
//               slivers: [
//                 // Encabezado "sticky" que permanece fijo al desplazarse
//                 SliverPersistentHeader(
//                   pinned: true,
//                   delegate: _StickyHeaderDelegate(
//                     minHeight: 30.0,
//                     maxHeight: 30.0,
//                     child: Container(
//                       color: Colors.blue,
//                       child: const Row(
//                         children: [
//                           Expanded(
//                               child: Text('ID',
//                                   style: TextStyle(color: Colors.white))),
//                           Expanded(
//                               child: Text('Fecha',
//                                   style: TextStyle(color: Colors.white))),
//                           Expanded(
//                               child: Text('Medición',
//                                   style: TextStyle(color: Colors.white))),
//                           Expanded(
//                               child: Text('Estado',
//                                   style: TextStyle(color: Colors.white))),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       if (index == _data.length) {
//                         return _isLoading
//                             ? const Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(16.0),
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               )
//                             : const SizedBox.shrink();
//                       }
//                       final item = _data[index];

//                       return Container(
//                         color: index % 2 == 0
//                             ? Colors.grey[200]
//                             : Colors.white, // Alterna los colores de las filas
//                         child: Row(
//                           children: [
//                             Expanded(child: Text(item.id.toString())),
//                             Expanded(child: Text(item.readDate)),
//                             Expanded(child: Text(item.measured)),
//                             Expanded(child: Text(item.status)),
//                           ],
//                         ),
//                       );
//                     },
//                     childCount: _data.length + (_hasMoreData ? 1 : 0),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// // Delegate para el encabezado sticky
// class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;

//   _StickyHeaderDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });

//   @override
//   double get minExtent => minHeight;

//   @override
//   double get maxExtent => maxHeight;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }
