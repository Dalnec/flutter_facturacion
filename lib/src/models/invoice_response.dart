import 'dart:convert';

import 'package:facturacion/src/models/models.dart' show Invoice;

class InvoiceResponse {
  int count;
  String? next;
  dynamic previous;
  List<Invoice> results;

  InvoiceResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory InvoiceResponse.fromRawJson(String str) =>
      InvoiceResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      InvoiceResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Invoice>.from(json["results"].map((x) => Invoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
