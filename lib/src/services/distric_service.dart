import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DistricService extends ChangeNotifier {
  final String _baseUrl = 'facturacionapi.tsi.pe';
  // final String _baseUrl = 'localhost:8000';

  Distric distric = Distric(
    name: '',
    address: '',
    representative: '',
    phone: '',
    email: '',
  );
  Settings settings = Settings(
    intervalTimeDevice: '0',
    width: '0',
    height: '0',
  );

  bool isLoading = true;
  bool isSaving = false;
  final storage = const FlutterSecureStorage();

  DistricService() {
    loadDistric();
    getSettings();
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

  Future getSettings() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, 'api/distric/1/get_settings/');
    final resp = await http.get(url);
    settings = Settings.fromJson(json.decode(resp.body));

    isLoading = false;
    notifyListeners();
  }

  Future updateSettings(Settings settings) async {
    final url =
        Uri.http(_baseUrl, 'api/distric/${distric.id}/update_settings/');
    /* {'Token': await storage.read(key: 'token')} */
    final resp = await http.put(
      url,
      body: settings.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print(resp.body);
    if (resp.statusCode != 200) return false;
    final settingsResponse = Settings.fromJson(json.decode(resp.body));
    settings = settingsResponse;
    notifyListeners();
    return true;
  }
}
