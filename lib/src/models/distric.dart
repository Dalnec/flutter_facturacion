import 'dart:convert';

class Distric {
  int? id;
  DateTime? created;
  DateTime? modified;
  String name;
  String address;
  String representative;
  String phone;
  String email;

  Distric({
    this.id,
    this.created,
    this.modified,
    required this.name,
    required this.address,
    required this.representative,
    required this.phone,
    required this.email,
  });

  factory Distric.fromRawJson(String str) => Distric.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Distric.fromJson(Map<String, dynamic> json) => Distric(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        name: json["name"],
        address: json["address"],
        representative: json["representative"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "name": name,
        "address": address,
        "representative": representative,
        "phone": phone,
        "email": email,
      };
}
