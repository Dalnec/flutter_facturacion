import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UsuarioService extends ChangeNotifier {
  final String _baseUrl = 'facturacionapi.tsi.pe';
  // final String _baseUrl = 'localhost:8000';

  List<Usuario> usuarios = [];
  late Usuario selectedUsuario = Usuario(
    ci: "",
    names: "",
    lastnames: "",
    gender: "",
    phone: "",
    email: "",
    family: "",
    address: "",
    status: "",
    employee: 0,
    makeInvoice: false,
    hasDebt: false,
    restart: false,
  );
  // late Usuario selectedUsuario;
  bool isLoading = true;
  bool isSaving = false;
  int _page = 0;
  int _count = 0;
  final storage = const FlutterSecureStorage();

  UsuarioService() {
    getUsuarios('', null, null, null);
  }

  Future saveOrCreateUsuario(Usuario usuario) async {
    isSaving = true;
    notifyListeners();
    if (usuario.id == null) {
      await createUsuario(usuario);
    } else {
      await updateUsuario(usuario);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateUsuario(Usuario usuario) async {
    // final url = Uri.https(_baseUrl, 'usuario/${usuario.id}',
    final url = Uri.https(_baseUrl, 'api/usuario/${usuario.id}/');
    /* {'Token': await storage.read(key: 'token')} */
    final resp = await http.put(
      url,
      body: usuario.usuarioToJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final decodedData = json.decode(resp.body);
    print(decodedData);
    final index = usuarios.indexWhere((element) => element.id == usuario.id);
    usuarios[index] = usuario;
    selectedUsuario = usuario;
    notifyListeners();
    return usuario.id.toString();
  }

  Future<String?> createUsuario(Usuario usuario) async {
    // final url = Uri.https(_baseUrl, 'usuario/${usuario.id}',
    final url = Uri.https(_baseUrl, 'api/usuario/');
    /* {'Token': await storage.read(key: 'token')} */
    usuario.username = usuario.ci.toString();
    usuario.password = usuario.ci.toString();
    usuario.profile = 3;
    final employee = await storage.read(key: 'employee');
    usuario.employee = int.parse(employee!);

    final resp = await http.post(
      url,
      body: usuario.usuarioToJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print("resp: ${resp.body}");
    final decodedData = json.decode(resp.body);
    usuario.id = decodedData['id'];
    usuarios.insert(0, usuario);
    return usuario.id.toString();
  }

  Future getUsuarios(
      String? search, bool? hasDebt, bool? makeInvoice, String? status,
      [int pageSize = 20, int page = 1]) async {
    isLoading = true;
    _page = page;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'search': search,
      'hasDebt': '$hasDebt',
      'makeInvoice': '$makeInvoice',
      'status': status,
    };

    // print(params);
    final url = Uri.https(_baseUrl, '/api/usuario/', params);
    // print('getUsuarios: $url');
    final resp = await http.get(url);
    final decodedData = utf8.decode(resp.bodyBytes);
    final jsonData = jsonDecode(decodedData);
    final usuarioResponse = UsuarioResponse.fromJson(jsonData);
    _count = usuarioResponse.count;
    usuarios = usuarioResponse.results;

    isLoading = false;
    notifyListeners();
  }

  Future getUsuario(String? id) async {
    isLoading = true;
    notifyListeners();

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.https(_baseUrl, '/api/usuario/$id/');
    final resp = await http.get(url);
    final decodedData = utf8.decode(resp.bodyBytes);
    final jsonData = jsonDecode(decodedData);
    final usuario = Usuario.fromJson(jsonData);

    selectedUsuario = usuario;

    isLoading = false;
    notifyListeners();
  }

  Future loadMoreUsuarios(
    String? search,
    bool? hasDebt,
    bool? makeInvoice,
    String? status,
  ) async {
    _page++;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '20',
      'page': '$_page',
      'search': search,
      'hasDebt': '$hasDebt',
      'makeInvoice': '$makeInvoice',
      'status': status,
    };
    // print("params: $params");
    if (_count > usuarios.length) {
      // final url = Uri.https(_baseUrl, '/api/login/');
      final url = Uri.https(_baseUrl, '/api/usuario/', params);
      // print('loadMoreUsuarios: $url');
      final resp = await http.get(url);
      final res = json.decode(resp.body);
      if (!res.containsKey('detail')) {
        final usuarioResponse = UsuarioResponse.fromJson(res);
        usuarios = [...usuarios, ...usuarioResponse.results];

        notifyListeners();
      }
    }
  }

  void changeStatus(int id) {
    final index = usuarios.indexWhere((element) => element.id == id);
    usuarios[index].hasDebt = true;
    usuarios[index].makeInvoice = false;
    selectedUsuario.makeInvoice = false;
    notifyListeners();
  }

  void changeStatusPayment(int id) async {
    await getUsuario('$id');
    final index = usuarios.indexWhere((element) => element.id == id);
    usuarios[index].hasDebt = selectedUsuario.hasDebt;
    usuarios[index].makeInvoice = selectedUsuario.makeInvoice;
    notifyListeners();
  }

  Future<bool> changePassword(String id, String password) async {
    final url = Uri.https(_baseUrl, 'api/usuario/$id/change_password/');
    final resp = await http.put(
      url,
      body: '{"password": "$password"}',
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return resp.statusCode == 201 ? true : false;
  }

  Future<bool> changeUsuarioStatus(int id, String status) async {
    final url = Uri.https(_baseUrl, 'api/usuario/$id/change_status/');
    final resp = await http.put(
      url,
      body: '{"status": "$status"}',
      headers: {
        'Content-Type': 'application/json',
      },
    );
    // return resp.statusCode == 200 ? true : false;
    if (resp.statusCode == 200) {
      final index = usuarios.indexWhere((element) => element.id == id);
      usuarios[index].status = status;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> restartUsuarioDetail(int id, UsuarioDetail? data) async {
    final url = Uri.https(_baseUrl, '/api/usuario/$id/restart_measured/');
    final resp = await http.put(
      url,
      body: data!.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode == 200) {
      return true;
    }
    return false;
  }
}
