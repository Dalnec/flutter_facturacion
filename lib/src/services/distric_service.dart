import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DistricService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.3:8000';

  Distric distric = Distric(
    name: '',
    address: '',
    representative: '',
    phone: '',
    email: '',
  );

  bool isLoading = true;
  bool isSaving = false;
  final storage = const FlutterSecureStorage();

  DistricService() {
    loadDistric();
  }

  Future updateDistric(Distric distric) async {
    final url = Uri.http(_baseUrl, 'api/distric/${distric.id}/');
    /* {'Token': await storage.read(key: 'token')} */
    final resp = await http.put(
      url,
      body: distric.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final districResponse = Distric.fromJson(json.decode(resp.body));
    distric = districResponse;
    notifyListeners();
  }

  Future loadDistric() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, 'api/distric');
    final resp = await http.get(url);
    final districResponse = DistricResponse.fromJson(json.decode(resp.body));
    distric = districResponse.results[0];

    isLoading = false;
    notifyListeners();
  }
}
