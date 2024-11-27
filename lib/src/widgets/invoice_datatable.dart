import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InvoiceDataTable extends StatefulWidget {
  final Usuario usuario;
  final int? year;

  const InvoiceDataTable({super.key, required this.usuario, this.year});

  @override
  _InvoiceDataTableState createState() => _InvoiceDataTableState();
}

class _InvoiceDataTableState extends State<InvoiceDataTable> {
  int _currentPage = 1;
  final int _pageSize = 12;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<Invoice> _data = [];
  final storage = const FlutterSecureStorage();
  String _profile = '';
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
    _profile = await storage.read(key: 'profile') ?? '';
    final String usuarioId;
    if (_profile == 'USUARIO') {
      usuarioId = await storage.read(key: 'usuario') ?? '';
    } else {
      usuarioId = "${widget.usuario.id}";
    }
    final invoiceService = Provider.of<InvoiceService>(context, listen: false);

    await invoiceService.getInvoicesResponse(
      usuarioId,
      widget.year,
      '-id',
      _pageSize,
      _currentPage,
    );
    final newData = invoiceService.invoices;

    if (newData.isEmpty) {
      _hasMoreData = false;
    } else {
      if (!mounted) return;
      setState(() {
        _data.addAll(newData);
      });
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _loadMoreData() {
    if (!_isLoading && _hasMoreData) {
      if (!mounted) return;
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
      _fetchData();
      _data.clear();
      _currentPage = 1;
      setState(() {});
    }
    return _data.isEmpty && _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    showCheckboxColumn: false,
                    headingRowColor:
                        const WidgetStatePropertyAll(AppTheme.primary),
                    headingRowHeight: 35,
                    columnSpacing: 18,
                    columns: const [
                      DataColumn(
                          label: Text(
                            'Periodo',
                            style: TextStyle(color: AppTheme.harp),
                          ),
                          headingRowAlignment: MainAxisAlignment.center),
                      DataColumn(
                          label: Text(
                            'Lectura',
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
                            'Estado',
                            style: TextStyle(color: AppTheme.harp),
                          ),
                          headingRowAlignment: MainAxisAlignment.center),
                    ],
                    rows: _data
                        .map((item) => DataRow(
                                onSelectChanged: (value) async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TicketScreen(
                                        invoice: item,
                                        data: item.ticket,
                                        status: item.status,
                                        profile: _profile,
                                      ),
                                    ),
                                  );
                                  if (result != null && result == 'reload') {
                                    setState(() {
                                      print("Datos recargados");
                                      // _fetchData();
                                    });
                                  }
                                },
                                cells: [
                                  DataCell(Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.period,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                  DataCell(Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.measured,
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
                                    child: Icon(Icons.check_circle,
                                        color: item.status == 'P'
                                            ? Colors.green
                                            : Colors.amber),
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
          );
  }
}
