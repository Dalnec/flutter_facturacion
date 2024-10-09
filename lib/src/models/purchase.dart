import 'dart:convert';

class Purchase {
  int? id;
  DateTime? created;
  DateTime? modified;
  String purchasedDate;
  String total;
  String liters;
  bool? active;
  String price;
  String? observations;
  int employee;

  Purchase({
    this.id,
    this.created,
    this.modified,
    required this.purchasedDate,
    required this.total,
    required this.liters,
    this.active,
    required this.price,
    this.observations,
    required this.employee,
  });

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
      };
}
