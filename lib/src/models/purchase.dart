import 'dart:convert';
import 'package:intl/intl.dart';

class Purchase {
  int? id;
  DateTime? created;
  DateTime? modified;
  String purchasedDate;
  String? total;
  String? liters;
  bool? active;
  String price;
  String? observations;
  int employee;
  String employeeName;

  Purchase({
    this.id,
    this.created,
    this.modified,
    required this.purchasedDate,
    this.total,
    this.liters,
    this.active,
    required this.price,
    this.observations,
    required this.employee,
    required this.employeeName,
  });

  int getMonth() {
    DateTime parsedDate = DateTime.parse(purchasedDate);
    return parsedDate.month - 1;
  }

  String formatedPurchasedDate() {
    // Parsear la cadena de fecha al objeto DateTime
    DateTime parsedDate = DateTime.parse(purchasedDate);

    // Formatear la fecha al formato deseado
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);

    return formattedDate;
  }

  String getActualDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }

  factory Purchase.fromRawJson(String str) =>
      Purchase.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        purchasedDate: json["purchased_date"],
        total: json["total"],
        liters: json["liters"],
        active: json["active"],
        price: json["price"],
        observations: json["observations"],
        employee: json["employee"],
        employeeName: json["employee_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "purchased_date": purchasedDate,
        "total": total,
        "liters": liters,
        "active": active,
        "price": price,
        "observations": observations,
        "employee": employee,
        "employee_name": employeeName,
      };

  Purchase copy() {
    return Purchase(
      id: id,
      created: created,
      modified: modified,
      purchasedDate: purchasedDate,
      total: total,
      liters: liters,
      active: active,
      price: price,
      observations: observations,
      employee: employee,
      employeeName: employeeName,
    );
  }
}
