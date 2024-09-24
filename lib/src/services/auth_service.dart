import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.3:8000';

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
      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(
          key: 'employee', value: '${decodedResp['user']['employee_id']}');
      return null;
    } else {
      return decodedResp['error'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
