import 'dart:convert';

import 'package:facturacion/src/models/models.dart' show UsuarioDetail;

class UsuarioDetailResponse {
  int count;
  dynamic next;
  dynamic previous;
  List<UsuarioDetail> results;

  UsuarioDetailResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory UsuarioDetailResponse.fromRawJson(String str) =>
      UsuarioDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UsuarioDetailResponse.fromJson(Map<String, dynamic> json) =>
      UsuarioDetailResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<UsuarioDetail>.from(
            json["results"].map((x) => UsuarioDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
