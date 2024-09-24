import 'dart:convert';
import 'package:facturacion/src/models/models.dart' show Monitoring;

class MonitoringResponse {
  int count;
  String? next;
  dynamic previous;
  List<Monitoring> results;

  MonitoringResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory MonitoringResponse.fromRawJson(String str) =>
      MonitoringResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MonitoringResponse.fromJson(Map<String, dynamic> json) =>
      MonitoringResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Monitoring>.from(
            json["results"].map((x) => Monitoring.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
