import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:provider/provider.dart';

class InvoiceDataTable extends StatefulWidget {
  const InvoiceDataTable({Key? key}) : super(key: key);

  @override
  _InvoiceDataTableState createState() => _InvoiceDataTableState();
}

class _InvoiceDataTableState extends State<InvoiceDataTable> {
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<Invoice> _data = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels + 200 ==
              _scrollController.position.maxScrollExtent &&
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final invoiceService = Provider.of<InvoiceService>(context, listen: false);

    await invoiceService.getInvoicesResponse('', _pageSize, _currentPage);
    final newData = invoiceService.response.results;

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
    return _data.isEmpty && _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                DataTable(
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
                          'Medido',
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
                            DataCell(Text(
                              item.readDate,
                              textAlign: TextAlign.center,
                            )),
                            DataCell(Text(
                              item.measured,
                              textAlign: TextAlign.center,
                            )),
                            DataCell(Text(
                              item.price,
                              textAlign: TextAlign.center,
                            )),
                            DataCell(Text(
                              item.total,
                              textAlign: TextAlign.center,
                            )),
                            DataCell(Text(
                              item.employee.toString(),
                              textAlign: TextAlign.center,
                            )),
                          ]))
                      .toList(),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
  }
}
