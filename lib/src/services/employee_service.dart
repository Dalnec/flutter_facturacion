import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart'
    show Employee, EmployeeResponse;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EmployeeService extends ChangeNotifier {
  final String _baseUrl = 'facturacionapi.tsi.pe';
  // final String _baseUrl = 'localhost:8000';

  List<Employee> employees = [];
  late Employee selectedEmployee = Employee(
    ci: "",
    names: "",
    lastnames: "",
    phone: "",
    email: "",
    address: "",
    status: "",
    employee: 0,
    username: '',
    profile: 0,
    user: 0,
  );

  bool isLoading = true;
  bool isSaving = false;
  int _page = 0;
  int _count = 0;
  final storage = const FlutterSecureStorage();

  EmployeeService() {
    getEmployee('');
  }

  Future saveOrCreateEmpleado(Employee employee) async {
    isSaving = true;
    notifyListeners();
    bool resp = false;
    if (employee.id == null) {
      resp = await createEmployee(employee);
    } else {
      resp = await updateEmployee(employee);
    }
    isSaving = false;
    notifyListeners();
    return resp;
  }

  Future<bool> updateEmployee(Employee employee) async {
    final url = Uri.https(_baseUrl, 'api/employee/${employee.id}/');
    final resp = await http.put(
      url,
      body: employee.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode == 200) {
      final index =
          employees.indexWhere((element) => element.id == employee.id);
      employees[index] = employee;
      return true;
    }
    return false;
  }

  Future<bool> createEmployee(Employee employee) async {
    final url = Uri.https(_baseUrl, 'api/employee/');
    employee.username = employee.ci.toString();
    employee.password = employee.ci.toString();
    final sysEmployee = await storage.read(key: 'employee');
    employee.employee = int.parse(sysEmployee!);

    final resp = await http.post(
      url,
      body: employee.toRawJson(),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode == 201) {
      final decodedData = json.decode(resp.body);
      employee.id = decodedData['id'];
      employees.insert(0, employee);
      return true;
    }
    return false;
  }

  Future getEmployee(String? search, [int pageSize = 20, int page = 1]) async {
    isLoading = true;
    _page = page;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '$pageSize',
      'page': '$page',
      'search': search,
    };

    final url = Uri.https(_baseUrl, '/api/employee/', params);
    final resp = await http.get(url);
    final employeeResponse = EmployeeResponse.fromJson(json.decode(resp.body));
    _count = employeeResponse.count;
    employees = employeeResponse.results;

    isLoading = false;
    notifyListeners();
  }

  Future getEmpleado(String? id) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, '/api/employee/$id/');
    final resp = await http.get(url);
    final employee = Employee.fromJson(json.decode(resp.body));

    selectedEmployee = employee;

    isLoading = false;
    notifyListeners();
  }

  Future loadMoreEmployee(String? search) async {
    _page++;
    notifyListeners();
    final Map<String, dynamic> params = {
      'page_size': '20',
      'page': '$_page',
      'search': search,
    };
    if (_count > employees.length) {
      final url = Uri.https(_baseUrl, '/api/employee/', params);
      final resp = await http.get(url);
      final employeeResponse =
          EmployeeResponse.fromJson(json.decode(resp.body));
      employees = [...employees, ...employeeResponse.results];

      notifyListeners();
    }
  }

  Future<bool> changePassword(String id, String password) async {
    final url = Uri.https(_baseUrl, 'api/employee/$id/change_password/');
    final resp = await http.put(
      url,
      body: '{"password": "$password"}',
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return resp.statusCode == 201 ? true : false;
  }

  Future<bool> changeStatus(String id, String status) async {
    final url = Uri.https(_baseUrl, 'api/employee/$id/change_status/');
    final resp = await http.put(
      url,
      body: '{"status": "$status"}',
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return resp.statusCode == 200 ? true : false;
  }
}
