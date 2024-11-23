import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart'
    show PurchaseResponse, Purchase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PurchaseService extends ChangeNotifier {
  // final String _baseUrl = 'facturacionapi.tsi.pe';
  final String _baseUrl = '192.168.1.4:8000';

  List<Purchase> purchases = [];
  PurchaseResponse response = PurchaseResponse(count: 0, results: []);
  late Purchase selectedPurchase;
  late Purchase lastPurchase;
  bool isLoading = false;
  bool isSaving = false;
  int _page = 0;
  int _count = 0;
  final storage = const FlutterSecureStorage();

  PurchaseService() {
    // getPurchases('');
  }

  Future getPurchases(String? search, int? year,
      [int pageSize = 10, int page = 1, ordering = "-id"]) async {
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'search': search,
      'year': year != null ? '$year' : '',
      'ordering': ordering,
    };

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.http(_baseUrl, '/api/purchase/', params);
    final resp = await http.get(url);
    final res = json.decode(resp.body);
    if (!res.containsKey('detail')) {
      final purchaseResponse =
          PurchaseResponse.fromJson(json.decode(resp.body));
      _count = purchaseResponse.count;
      purchases = purchaseResponse.results;
      response = purchaseResponse;
    } else {
      purchases = [];
    }

    notifyListeners();
  }

  Future getPurchasesResponse(String? search,
      [int pageSize = 10, int page = 1]) async {
    isLoading = true;
    _page = page;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'search': search,
    };

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.http(_baseUrl, '/api/purchase/', params);
    final resp = await http.get(url);
    response = PurchaseResponse.fromJson(json.decode(resp.body));
    purchases = response.results;
    isLoading = false;
    notifyListeners();
  }

  Future createPurchase(Purchase purchase) async {
    purchase.purchasedDate = purchase.getActualDateTime();
    purchase.employee = int.parse('${await storage.read(key: 'employee')}');
    final url = Uri.http(_baseUrl, '/api/purchase/');
    final resp = await http.post(
      url,
      body: purchase.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return resp.statusCode == 201 ? true : false;
  }

  Future getLastPurchase() async {
    final url = Uri.http(_baseUrl, '/api/purchase/get_last_purchase/');
    final resp = await http.get(url);
    if (resp.statusCode != 200) {
      lastPurchase =
          Purchase(purchasedDate: '', price: '', employee: 0, employeeName: '');
      return;
    }
    lastPurchase = Purchase.fromJson(json.decode(resp.body));

    notifyListeners();
  }
}
