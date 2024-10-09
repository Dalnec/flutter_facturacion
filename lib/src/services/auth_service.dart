import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'facturacionapi.tsi.pe';

  Map<String, dynamic> user = {};
  final storage = const FlutterSecureStorage();

  Future<String?> createUser(String username, String password) async {
    final Map<String, dynamic> authData = {
      'username': username,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp');

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      await storage.write(
          key: 'employee', value: decodedResp['user']['employee_id']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String username, String password) async {
    final Map<String, dynamic> authData = {
      'username': username,
      'password': password,
    };

    // final url = Uri.https(_baseUrl, '/api/login/');
    final url = Uri.http(_baseUrl, '/api/login/');

    final resp = await http.post(url, body: authData);
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('token')) {
      user = decodedResp['user'];
      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(
        key: 'employee',
        value: '${decodedResp['user']['employee_id']}',
      );
      await storage.write(
        key: 'profile',
        value: '${decodedResp['user']['profile_description']}',
      );
      return null;
    } else {
      return decodedResp['error'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'employee');
    await storage.delete(key: 'profile');
  }

  Future<String> readToken() async {
    final token = await storage.read(key: 'token') ?? '';
    final employee = await storage.read(key: 'employee');
    final profile = await storage.read(key: 'profile');
    return token.isNotEmpty ? "$token;$employee;$profile" : '';
  }
}
