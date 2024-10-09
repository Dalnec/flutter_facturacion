import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart'
    show PurchaseResponse, Purchase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PurchaseService extends ChangeNotifier {
  final String _baseUrl = 'facturacionapi.tsi.pe';

  List<Purchase> purchases = [];
  PurchaseResponse response = PurchaseResponse(count: 0, results: []);
  late Purchase selectedPurchase;
  bool isLoading = true;
  bool isSaving = false;
  int _page = 0;
  int _count = 0;
  final storage = const FlutterSecureStorage();

  PurchaseService() {
    // getPurchases('');
  }

  Future getPurchases(String? search, [int pageSize = 10, int page = 1]) async {
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'search': search,
    };

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.http(_baseUrl, '/api/purchase/', params);
    final resp = await http.get(url);
    final purchaseResponse = PurchaseResponse.fromJson(json.decode(resp.body));
    _count = purchaseResponse.count;
    purchases = purchaseResponse.results;
    response = purchaseResponse;

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
    print(resp.body);
    response = PurchaseResponse.fromJson(json.decode(resp.body));
    purchases = response.results;
    isLoading = false;
    notifyListeners();
  }

  Future createPurchase(Purchase purchase) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/purchase/');
    final resp = await http.post(
      url,
      body: purchase.toJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print(resp.body);
    response = PurchaseResponse.fromJson(json.decode(resp.body));
    purchases = response.results;
    isLoading = false;
    notifyListeners();
  }
}
