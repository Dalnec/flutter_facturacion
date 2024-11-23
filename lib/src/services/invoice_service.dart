import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class InvoiceService extends ChangeNotifier {
  // final String _baseUrl = 'facturacionapi.tsi.pe';
  final String _baseUrl = 'localhost:8000';

  InvoiceResponse response = InvoiceResponse(count: 0, results: []);
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

  Future updateInvoice(Invoice invoice) async {
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

    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final index = invoices.indexWhere((element) => element.id == invoice.id);
      invoices[index] = invoice;
      return {"status": true, "invoice": decodedData};
    }
    return {"status": false};
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
    print("invoice: ${invoice.toRawJson()}");
    print("response: ${resp.statusCode}");
    if (resp.statusCode != 201) {
      return invoice;
    }
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
    final url = Uri.http(_baseUrl, '/api/invoice/', params);
    final resp = await http.get(url);
    final res = json.decode(resp.body);
    if (!res.containsKey('detail')) {
      final invoiceResponse = InvoiceResponse.fromJson(json.decode(resp.body));
      _count = invoiceResponse.count;
      invoices = invoiceResponse.results;

      isLoading = false;
      notifyListeners();
    } else {
      invoices = [];
    }
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
      final url = Uri.http(_baseUrl, '/api/invoice/', params);
      final resp = await http.get(url);
      final invoiceResponse = InvoiceResponse.fromJson(json.decode(resp.body));
      invoices = [...invoices, ...invoiceResponse.results];

      notifyListeners();
    }
  }

  Future getInvoicesResponse(String? usuarioId, int? year,
      [ordering = "-id", int pageSize = 10, int page = 1]) async {
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'usuario': usuarioId,
      'year': year != null ? '$year' : '',
      'ordering': ordering,
    };

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.http(_baseUrl, '/api/invoice/', params);
    final resp = await http.get(url);
    final res = json.decode(resp.body);
    if (!res.containsKey('detail')) {
      response = InvoiceResponse.fromJson(json.decode(resp.body));
      invoices = response.results;
      notifyListeners();
    } else {
      invoices = [];
    }
  }

  Future updateStatusInvoice(Invoice invoice) async {
    final url = Uri.http(_baseUrl, 'api/invoice/${invoice.id}/change_status/');
    final resp = await http.put(
      url,
      body: '{"status": "${invoice.status}"}',
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode == 200) {
      final index = invoices.indexWhere((element) => element.id == invoice.id);
      invoices[index].status = 'P';
      return true;
    }
    return false;
  }
}
