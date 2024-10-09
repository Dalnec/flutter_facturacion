import 'dart:convert';

import 'package:facturacion/src/models/models.dart' show Purchase;

class PurchaseResponse {
  int count;
  dynamic next;
  dynamic previous;
  List<Purchase> results;

  PurchaseResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PurchaseResponse.fromRawJson(String str) =>
      PurchaseResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseResponse.fromJson(Map<String, dynamic> json) =>
      PurchaseResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Purchase>.from(
            json["results"].map((x) => Purchase.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
