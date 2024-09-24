import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class InvoiceService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.3:8000';

  List<Invoice> invoices = [];
  late Invoice selectedInvoice;
  bool isLoading = true;
  bool isSaving = false;
  int _page = 0;
  int _count = 0;
  final storage = const FlutterSecureStorage();

  InvoiceService() {
    // getInvoices('');
  }

  Future saveOrCreateInvoice(Invoice invoice) async {
    final Invoice newInvoice;
    isSaving = true;
    notifyListeners();
    if (invoice.id == null) {
      newInvoice = await createInvoice(invoice);
    } else {
      newInvoice = await updateInvoice(invoice);
    }
    isSaving = false;
    notifyListeners();
    return newInvoice;
  }

  Future<Invoice> updateInvoice(Invoice invoice) async {
    // final url = Uri.https(_baseUrl, 'Invoice/${Invoice.id}',
    final url = Uri.http(_baseUrl, 'api/invoice/${invoice.id}/');
    /* {'Token': await storage.read(key: 'token')} */
    final resp = await http.put(
      url,
      body: invoice.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final decodedData = json.decode(resp.body);
    print(decodedData);
    final index = invoices.indexWhere((element) => element.id == invoice.id);
    invoices[index] = invoice;

    return decodedData;
  }

  Future<Invoice> createInvoice(Invoice invoice) async {
    // final url = Uri.https(_baseUrl, 'Invoice/${Invoice.id}',
    final url = Uri.http(_baseUrl, 'api/invoice/');
    /* {'Token': await storage.read(key: 'token')} */
    final employee = await storage.read(key: 'employee');
    invoice.employee = int.parse(employee!);

    final resp = await http.post(
      url,
      body: invoice.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final decodedData = Invoice.fromRawJson(resp.body);
    return decodedData;
  }

  Future getInvoices(String? search, [int pageSize = 20, int page = 1]) async {
    isLoading = true;
    _page = page;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'search': search,
    };

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.http(_baseUrl, '/api/Invoice/', params);
    final resp = await http.get(url);
    final invoiceResponse = InvoiceResponse.fromJson(json.decode(resp.body));
    _count = invoiceResponse.count;
    invoices = invoiceResponse.results;

    isLoading = false;
    notifyListeners();
  }

  Future loadMoreInvoices(String? search) async {
    _page++;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '20',
      'page': '$_page',
      'search': search,
    };
    if (_count > invoices.length) {
      // final url = Uri.https(_baseUrl, '/api/login/');
      final url = Uri.http(_baseUrl, '/api/Invoice/', params);
      final resp = await http.get(url);
      final invoiceResponse = InvoiceResponse.fromJson(json.decode(resp.body));
      invoices = [...invoices, ...invoiceResponse.results];

      notifyListeners();
    }
  }
}
