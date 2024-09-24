// import 'dart:ui';
import 'package:facturacion/src/widgets/paginated_datatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/models/models.dart'
    show Monitoring, MonitoringResponse;
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/monitoring/water_tank_level.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:facturacion/src/services/services.dart' show MonitoringService;

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    final monitoringService = Provider.of<MonitoringService>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          // appBar: AppBar(
          //   title: const Text("Monitoreo"),
          // ),
          appBar: AppBar(
            title: const Text(
              'My Profile',
            ),
            centerTitle: true,
            backgroundColor: Colors.grey[700],
            elevation: 0,
            // give the app bar rounded corners
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            leading: const Icon(
              Icons.menu,
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                const SliverToBoxAdapter(child: WaterTankLevel()),
                const SliverToBoxAdapter(
                  child: TabBar(
                    // controller: _controller,
                    tabs: [
                      Tab(
                        child: Text(
                          "Semanal",
                          style: TextStyle(color: AppTheme.primary),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Mensual",
                          style: TextStyle(color: AppTheme.primary),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Anual",
                          style: TextStyle(color: AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: Container(
              child: TabBarView(
                // controller: _controller,
                children: [
                  //           // first tab bar view widget
                  const Padding(
                      padding: EdgeInsets.all(8.0),
                      // child: _CardContainer(
                      //     child: PaginatedDataTableWidget(
                      //   source: _MyDataTableSource(
                      //     monitoringService.response,
                      //     monitoringService,
                      //   ),
                      //   headingRowColor: AppTheme.primary,
                      //   columns: _columnsDataTable(),
                      //   monitoringService: monitoringService,
                      // )),
                      // child: _CardContainer(child: PaginatedDataTableView())),
                      child: InfiniteScrollDataTable()),
                  // child: StickyHeaderDataTable()),

                  // second tab bar viiew widget
                  Container(
                    // color: Colors.pink,
                    child: const Center(
                      child: Text(
                        'Car',
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.pink,
                    child: const Center(
                      child: Text(
                        'Motorbike',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          // body: Column(
          //   children: <Widget>[
          //     // construct the profile details widget here
          //     const SizedBox(
          //       height: 270,
          //       child: WaterTankLevel(),
          //     ),

          //     SizedBox(
          //       height: 50,
          //       child: AppBar(
          //         backgroundColor: Colors.white,
          //         bottom: const TabBar(
          //           indicatorColor: AppTheme.primary,
          //           indicatorWeight: 4,
          //           tabs: [
          //             Tab(
          //               child: Text(
          //                 "Semanal",
          //                 style: TextStyle(color: AppTheme.primary),
          //               ),
          //             ),
          //             Tab(
          //               child: Text(
          //                 "Mensual",
          //                 style: TextStyle(color: AppTheme.primary),
          //               ),
          //             ),
          //             Tab(
          //               child: Text(
          //                 "Anual",
          //                 style: TextStyle(color: AppTheme.primary),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),

          //     // create widgets for each tab bar here
          //     Expanded(
          //       child: TabBarView(
          //         children: [
          //           // first tab bar view widget
          //           SingleChildScrollView(
          //             child: Container(
          //               // color: Colors.red,
          //               child: const Center(
          //                 child: Text(
          //                   'Bike',
          //                 ),
          //               ),
          //             ),
          //           ),

          //           // second tab bar viiew widget
          //           Container(
          //             // color: Colors.pink,
          //             child: const Center(
          //               child: Text(
          //                 'Car',
          //               ),
          //             ),
          //           ),
          //           Container(
          //             // color: Colors.pink,
          //             child: const Center(
          //               child: Text(
          //                 'Motorbike',
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}

// DataTableInfo
class _MyDataTableSource extends DataTableSource {
  // Lista de datos a mostrar en la tabla
  final MonitoringResponse _data;
  final MonitoringService monitoringService;

  _MyDataTableSource(this._data, this.monitoringService);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.count) return null;

    final item = _data.results[index];

    return DataRow(
      color: const WidgetStatePropertyAll(Colors.white),
      cells: [
        DataCell(Text(item.id.toString())),
        DataCell(Text(item.readDate)),
        DataCell(Text(item.measured)),
        DataCell(Text(item.status)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.count;

  @override
  int get selectedRowCount => 0;
}

List<DataColumn> _columnsDataTable() {
  return [
    const DataColumn(label: Text('ID', style: TextStyle(color: AppTheme.harp))),
    const DataColumn(
        label: Text('Fecha', style: TextStyle(color: AppTheme.harp))),
    const DataColumn(
        label: Text('Medición', style: TextStyle(color: AppTheme.harp))),
    const DataColumn(
        label: Text('Estado', style: TextStyle(color: AppTheme.harp))),
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
