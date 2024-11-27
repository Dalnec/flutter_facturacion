import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

class Usuario {
  int? id;
  DateTime? created;
  DateTime? modified;
  String ci;
  String names;
  String lastnames;
  String? gender;
  String? phone;
  String? email;
  String family;
  String address;
  String status;
  int? user;
  int? profile;
  int employee;
  String? username;
  String? password;
  bool? hasDebt;
  bool makeInvoice;
  String? code;
  String? lastMeasured; // solo al registrar primera vez
  bool restart;
  String? lastInvoice;

  Usuario({
    this.id,
    this.created,
    this.modified,
    required this.ci,
    required this.names,
    required this.lastnames,
    this.gender,
    this.phone,
    this.email,
    required this.family,
    required this.address,
    required this.status,
    this.user,
    this.profile,
    required this.employee,
    this.hasDebt,
    required this.makeInvoice,
    this.code,
    this.lastMeasured,
    required this.restart,
    this.lastInvoice,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        ci: json["ci"],
        names: json["names"],
        lastnames: json["lastnames"],
        gender: json["gender"],
        phone: json["phone"],
        email: json["email"],
        family: json["family"],
        address: json["address"],
        status: json["status"],
        user: json["user"],
        profile: json["profile"],
        employee: json["employee"],
        hasDebt: json["hasDebt"],
        makeInvoice: json["makeInvoice"],
        code: json["code"],
        lastMeasured: json["last_measured"],
        restart: json["restart"],
        lastInvoice: json["lastInvoice"],
      );

  // String usuarioToJson(Usuario data) => json.encode(data.toJson());
  String usuarioToJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "ci": ci,
        "names": names,
        "lastnames": lastnames,
        "gender": gender,
        "phone": phone,
        "email": email,
        "family": family,
        "address": address,
        "status": status,
        "user": user,
        "profile": profile,
        "employee": employee,
        "username": username,
        "password": password,
        "hasDebt": hasDebt,
        "makeInvoice": makeInvoice,
        "code": code,
        "last_measured": lastMeasured,
        "restart": restart,
        "lastInvoice": lastInvoice,
      };

  Usuario copy() => Usuario(
        id: id,
        created: created,
        modified: modified,
        ci: ci,
        names: names,
        lastnames: lastnames,
        gender: gender,
        phone: phone,
        email: email,
        family: family,
        address: address,
        status: status,
        user: user,
        profile: profile,
        employee: employee,
        hasDebt: hasDebt,
        makeInvoice: makeInvoice,
        code: code,
        lastMeasured: lastMeasured,
        restart: restart,
        lastInvoice: lastInvoice,
      );
}
