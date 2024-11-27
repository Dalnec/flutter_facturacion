import 'dart:convert';
import 'package:intl/intl.dart';

class Monitoring {
  int? id;
  DateTime? created;
  DateTime? modified;
  String readDate;
  String measured;
  String status;
  String? observations;
  String percentage;
  bool? isConnected;
  String battery;
  double? liters;
  String? height;
  double? capacity;

  Monitoring({
    this.id,
    this.created,
    this.modified,
    required this.readDate,
    required this.measured,
    required this.status,
    this.observations,
    required this.percentage,
    this.isConnected,
    required this.battery,
    this.liters,
    this.height,
    this.capacity,
  });

  String formatedReadDate() {
    DateTime parsedDate = DateTime.parse(readDate);
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
    return formattedDate;
  }

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
        battery: json["battery"],
        liters: json["liters"],
        height: json["height"],
        capacity: json["capacity"],
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
        "battery": battery,
        "liters": liters,
        "height": height,
        "capacity": capacity,
      };
}
