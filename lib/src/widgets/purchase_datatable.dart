import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:provider/provider.dart';

class PurchaseDataTable extends StatefulWidget {
  final int? year;
  final bool? reload;

  const PurchaseDataTable({super.key, this.year, this.reload});

  @override
  _PurchaseDataTableState createState() => _PurchaseDataTableState();
}

class _PurchaseDataTableState extends State<PurchaseDataTable> {
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<Purchase> _data = [];
  int _year = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          _hasMoreData) {
        _loadMoreData();
      }
    });
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

    final purchaseService =
        Provider.of<PurchaseService>(context, listen: false);

    await purchaseService.getPurchases(
        '', widget.year, _pageSize, _currentPage);
    final newData = purchaseService.purchases;

    if (newData.isEmpty) {
      _hasMoreData = false;
    } else {
      setState(() {
        _data.addAll(newData);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _loadMoreData() {
    if (!_isLoading && _hasMoreData) {
      setState(() {
        _currentPage++;
      });
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_year != widget.year && widget.year != null) {
      _year = widget.year!;
      _currentPage = 1;
      _data.clear();
      _fetchData();
      setState(() {});
    }

    if (widget.reload == true) {
      _currentPage = 1;
      _data.clear();
      _fetchData();
      setState(() {});
    }
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
                      headingRowColor:
                          const WidgetStatePropertyAll(AppTheme.primary),
                      headingRowHeight: 30,
                      dataRowMaxHeight: 35,
                      dataRowMinHeight: 20,
                      columnSpacing: 18,
                      columns: const [
                        DataColumn(
                            label: Text(
                              'Fecha',
                              style: TextStyle(color: AppTheme.harp),
                            ),
                            headingRowAlignment: MainAxisAlignment.center),
                        // DataColumn(
                        //     label: Text(
                        //       'Cantidad',
                        //       style: TextStyle(color: AppTheme.harp),
                        //     ),
                        //     headingRowAlignment: MainAxisAlignment.center),
                        DataColumn(
                            label: Text(
                              'Precio',
                              style: TextStyle(color: AppTheme.harp),
                            ),
                            headingRowAlignment: MainAxisAlignment.center),
                        // DataColumn(
                        //     label: Text(
                        //       'Total',
                        //       style: TextStyle(color: AppTheme.harp),
                        //     ),
                        //     headingRowAlignment: MainAxisAlignment.center),
                        DataColumn(
                            label: Text(
                              'Encargado',
                              style: TextStyle(color: AppTheme.harp),
                            ),
                            headingRowAlignment: MainAxisAlignment.center),
                      ],
                      rows: _data
                          .map((item) => DataRow(cells: [
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.formatedPurchasedDate(),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                                // DataCell(Container(
                                //   alignment: Alignment.center,
                                //   child: Text(
                                //     item.liters,
                                //     textAlign: TextAlign.center,
                                //   ),
                                // )),
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.price,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                                // DataCell(Container(
                                //   alignment: Alignment.center,
                                //   child: Text(
                                //     item.total,
                                //     textAlign: TextAlign.center,
                                //   ),
                                // )),
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.employeeName.toString(),
                                    textAlign: TextAlign.center,
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
