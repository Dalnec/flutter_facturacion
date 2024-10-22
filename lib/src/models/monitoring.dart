import 'dart:convert';

class Monitoring {
  int? id;
  DateTime? created;
  DateTime? modified;
  String readDate;
  String measured;
  String status;
  String? observations;
  String percentage;
  bool isConnected;

  Monitoring({
    this.id,
    this.created,
    this.modified,
    required this.readDate,
    required this.measured,
    required this.status,
    this.observations,
    required this.percentage,
    required this.isConnected,
  });

  factory Monitoring.fromRawJson(String str) =>
      Monitoring.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Monitoring.fromJson(Map<String, dynamic> json) => Monitoring(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        readDate: json["read_date"],
        measured: json["measured"],
        status: json["status"],
        observations: json["observations"],
        percentage: json["percentage"],
        isConnected: json["isConnected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "read_date": readDate,
        "measured": measured,
        "status": status,
        "observations": observations,
        "percentage": percentage,
        "isConnected": isConnected,
      };
}
