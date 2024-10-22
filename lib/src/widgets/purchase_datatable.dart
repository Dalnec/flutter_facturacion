import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:provider/provider.dart';

class PurchaseDataTable extends StatefulWidget {
  const PurchaseDataTable({Key? key}) : super(key: key);

  @override
  _PurchaseDataTableState createState() => _PurchaseDataTableState();
}

class _PurchaseDataTableState extends State<PurchaseDataTable> {
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<Purchase> _data = [];

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

    await purchaseService.getPurchases('', _pageSize, _currentPage);
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
                      headingRowHeight: 35,
                      columnSpacing: 18,
                      columns: const [
                        DataColumn(
                            label: Text(
                              'Fecha',
                              style: TextStyle(color: AppTheme.harp),
                            ),
                            headingRowAlignment: MainAxisAlignment.center),
                        DataColumn(
                            label: Text(
                              'Cantidad',
                              style: TextStyle(color: AppTheme.harp),
                            ),
                            headingRowAlignment: MainAxisAlignment.center),
                        DataColumn(
                            label: Text(
                              'Precio',
                              style: TextStyle(color: AppTheme.harp),
                            ),
                            headingRowAlignment: MainAxisAlignment.center),
                        DataColumn(
                            label: Text(
                              'Total',
                              style: TextStyle(color: AppTheme.harp),
                            ),
                            headingRowAlignment: MainAxisAlignment.center),
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
                                    item.purchasedDate,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.liters,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.price,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.total,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                                DataCell(Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    item.employee.toString(),
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
