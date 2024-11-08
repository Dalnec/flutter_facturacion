import 'dart:convert';
import 'package:facturacion/src/models/models.dart' show Employee;

class EmployeeResponse {
  int count;
  dynamic next;
  dynamic previous;
  List<Employee> results;

  EmployeeResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory EmployeeResponse.fromRawJson(String str) =>
      EmployeeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) =>
      EmployeeResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Employee>.from(
            json["results"].map((x) => Employee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
