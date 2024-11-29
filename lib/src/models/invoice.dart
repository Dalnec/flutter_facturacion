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
  String previosMeasured;
  String? uuid;
  double? measuredDiff;

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
    required this.previosMeasured,
    this.uuid,
    this.measuredDiff,
  });

  int getMonth() {
    // Convertir el String a DateTime
    DateTime parsedDate = DateTime.parse(readDate);

    // Retornar el mes
    return parsedDate.month - 1;
  }

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
        previosMeasured: json["previosMeasured"],
        uuid: json["uuid"],
        measuredDiff: json["measured_diff"],
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
        "previosMeasured": previosMeasured,
        "uuid": uuid,
        "measured_diff": measuredDiff,
      };

  Invoice copy() => Invoice(
        id: id,
        created: created,
        modified: modified,
        readDate: readDate,
        measured: measured,
        price: price,
        total: total,
        status: status,
        observations: observations,
        employee: employee,
        usuario: usuario,
        period: period,
        ticket: ticket,
        previosMeasured: previosMeasured,
        uuid: uuid,
        measuredDiff: measuredDiff,
      );
}
