import 'dart:convert';

class Invoice {
  int? id;
  DateTime? created;
  DateTime? modified;
  String readDate;
  String measured;
  String price;
  String total;
  String status;
  String ticket;
  String? observations;
  int employee;
  int usuario;
  String period;

  Invoice({
    this.id,
    this.created,
    this.modified,
    required this.readDate,
    required this.measured,
    required this.price,
    required this.total,
    required this.status,
    this.observations,
    required this.employee,
    required this.usuario,
    required this.period,
    required this.ticket,
  });

  factory Invoice.fromRawJson(String str) => Invoice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        readDate: json["read_date"],
        measured: json["measured"],
        price: json["price"],
        total: json["total"],
        status: json["status"],
        observations: json["observations"],
        employee: json["employee"],
        usuario: json["usuario"],
        period: json["period"],
        ticket: json["ticket"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "read_date": readDate,
        "measured": measured,
        "price": price,
        "total": total,
        "status": status,
        "observations": observations,
        "employee": employee,
        "usuario": usuario,
        "period": period,
        "ticket": ticket,
      };
}
