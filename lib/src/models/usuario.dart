import 'dart:convert';

import 'package:facturacion/src/models/models.dart' show Usuario;

UsuarioResponse usuarioResponseFromJson(String str) =>
    UsuarioResponse.fromJson(json.decode(str));

String usuarioResponseToJson(UsuarioResponse data) =>
    json.encode(data.toJson());

class UsuarioResponse {
  int count;
  dynamic next;
  dynamic previous;
  List<Usuario> results;

  UsuarioResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) =>
      UsuarioResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Usuario>.from(json["results"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<Usuario>.from(results.map((x) => x.toJson())),
      };
}
