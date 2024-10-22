import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart'
    show MonitoringResponse, Monitoring;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MonitoringService extends ChangeNotifier {
  final String _baseUrl = 'facturacionapi.tsi.pe';

  List<Monitoring> monitorings = [];
  Monitoring lastMonitoring = Monitoring(
      readDate: '',
      measured: '',
      status: '',
      percentage: '',
      isConnected: false);
  MonitoringResponse response = MonitoringResponse(count: 0, results: []);
  late Monitoring selectedMonitoring;
  bool isLoading = true;
  bool isSaving = false;
  int _page = 0;
  int _count = 0;
  final storage = const FlutterSecureStorage();

  MonitoringService() {
    // getMonitorings('');
  }

  Future getMonitorings(String? search,
      [int pageSize = 10, int page = 1]) async {
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'search': search,
    };

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.http(_baseUrl, '/api/monitoring/', params);
    final resp = await http.get(url);
    final res = json.decode(resp.body);
    if (!res.containsKey('detail')) {
      final monitoringResponse =
          MonitoringResponse.fromJson(json.decode(resp.body));
      _count = monitoringResponse.count;
      monitorings = monitoringResponse.results;
      response = monitoringResponse;
    } else {
      monitorings = [];
    }

    notifyListeners();
  }

  Future getMonitoringsResponse(String? search,
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
    final url = Uri.http(_baseUrl, '/api/monitoring/', params);
    final resp = await http.get(url);
    print(resp.body);
    response = MonitoringResponse.fromJson(json.decode(resp.body));
    monitorings = response.results;
    isLoading = false;
    notifyListeners();
  }

  Future getLastReading() async {
    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.http(_baseUrl, '/api/monitoring/get_last/');
    final resp = await http.get(url);
    lastMonitoring = Monitoring.fromJson(json.decode(resp.body));
    notifyListeners();
  }
}
