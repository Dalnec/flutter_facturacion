import 'dart:convert';
import 'package:facturacion/src/models/models.dart' show Distric;

class DistricResponse {
  int count;
  dynamic next;
  dynamic previous;
  List<Distric> results;

  DistricResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory DistricResponse.fromRawJson(String str) =>
      DistricResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DistricResponse.fromJson(Map<String, dynamic> json) =>
      DistricResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Distric>.from(json["results"].map((x) => Distric.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
