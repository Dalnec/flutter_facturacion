import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UsuarioDetailDetailService extends ChangeNotifier {
  final String _baseUrl = 'facturacionapi.tsi.pe';
  // final String _baseUrl = 'localhost:8000';

  List<UsuarioDetail> details = [];
  late UsuarioDetail selectedUsuarioDetail = UsuarioDetail(
    description: '',
    price: '',
    quantity: '',
    isIncome: true,
    usuario: 0,
    status: true,
  );
  bool isLoading = true;
  bool isSaving = false;
  int _page = 0;
  int _count = 0;
  final storage = const FlutterSecureStorage();

  UsuarioDetailDetailService() {
    getUsuarioDetails('');
  }

  Future saveOrCreateUsuarioDetail(UsuarioDetail usuario) async {
    isSaving = true;
    notifyListeners();
    final String? res;
    if (usuario.id == null) {
      res = await createUsuarioDetail(usuario);
    } else {
      res = await updateUsuarioDetail(usuario);
    }
    isSaving = false;
    notifyListeners();
    return res;
  }

  Future<String> updateUsuarioDetail(UsuarioDetail detail) async {
    final url = Uri.https(_baseUrl, 'api/usuariodetail/${detail.id}/');
    final resp = await http.put(
      url,
      body: detail.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final decodedData = json.decode(resp.body);
    print(decodedData);
    final index = details.indexWhere((element) => element.id == detail.id);
    details[index] = detail;

    return detail.id.toString();
  }

  Future<String?> createUsuarioDetail(UsuarioDetail detail) async {
    final url = Uri.https(_baseUrl, 'api/usuariodetail/');

    final resp = await http.post(
      url,
      body: detail.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    // print("resp: ${resp.body}");
    final decodedData = UsuarioDetail.fromJson(json.decode(resp.body));
    detail.id = decodedData.id;
    details.insert(0, decodedData);
    return detail.id.toString();
  }

  Future getUsuarioDetails(String? usuario,
      [int pageSize = 10, int page = 1]) async {
    isLoading = true;
    _page = page;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'usuario': usuario,
    };

    final url = Uri.https(_baseUrl, '/api/usuariodetail/', params);
    // print('getUsuarioDetails: $url');
    final resp = await http.get(url);
    // print(resp.body);
    final usuarioResponse =
        UsuarioDetailResponse.fromJson(json.decode(resp.body));
    _count = usuarioResponse.count;
    details = usuarioResponse.results;

    isLoading = false;
    notifyListeners();
  }

  Future getUsuarioDetail(String? id) async {
    isLoading = true;
    notifyListeners();

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.https(_baseUrl, '/api/usuario/$id/');
    final resp = await http.get(url);
    final usuario = UsuarioDetail.fromJson(json.decode(resp.body));

    selectedUsuarioDetail = usuario;

    isLoading = false;
    notifyListeners();
  }

  Future loadMoreUsuarioDetails(String? usuario) async {
    _page++;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '10',
      'page': '$_page',
      'usuario': usuario,
    };
    if (_count > details.length) {
      final url = Uri.https(_baseUrl, '/api/usuario/', params);
      final resp = await http.get(url);
      final res = json.decode(resp.body);
      if (!res.containsKey('detail')) {
        final usuarioResponse = UsuarioDetailResponse.fromJson(res);
        details = [...details, ...usuarioResponse.results];

        notifyListeners();
      }
    }
  }

  // void changeStatus(int id) {
  //   final index = usuarios.indexWhere((element) => element.id == id);
  //   usuarios[index].hasDebt = true;
  //   usuarios[index].makeInvoice = false;
  //   selectedUsuarioDetail.makeInvoice = false;
  //   notifyListeners();
  // }

  // void changeStatusPayment(int id) async {
  //   await getUsuarioDetail('$id');
  //   final index = usuarios.indexWhere((element) => element.id == id);
  //   usuarios[index].hasDebt = selectedUsuarioDetail.hasDebt;
  //   usuarios[index].makeInvoice = selectedUsuarioDetail.makeInvoice;
  //   notifyListeners();
  // }

  // Future<bool> changeUsuarioDetailStatus(int id, String status) async {
  //   final url = Uri.https(_baseUrl, 'api/usuario/$id/change_status/');
  //   final resp = await http.put(
  //     url,
  //     body: '{"status": "$status"}',
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //   // return resp.statusCode == 200 ? true : false;
  //   if (resp.statusCode == 200) {
  //     final index = details.indexWhere((element) => element.id == id);
  //     details[index].status = status;
  //     notifyListeners();
  //     return true;
  //   }
  //   return false;
  // }
}
