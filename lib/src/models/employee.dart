import 'dart:convert';

class Employee {
  int? id;
  String username;
  String? password;
  int profile;
  String? profileDescription;
  DateTime? created;
  DateTime? modified;
  String ci;
  String names;
  String lastnames;
  String? email;
  String? phone;
  String? address;
  String status;
  int? user;
  int? employee;

  Employee({
    this.id,
    required this.username,
    this.password,
    required this.profile,
    this.profileDescription,
    this.created,
    this.modified,
    required this.ci,
    required this.names,
    required this.lastnames,
    this.email,
    this.phone,
    this.address,
    required this.status,
    this.user,
    this.employee,
  });

  factory Employee.fromRawJson(String str) =>
      Employee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        profile: json["profile"],
        profileDescription: json["profile_description"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        ci: json["ci"],
        names: json["names"],
        lastnames: json["lastnames"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        status: json["status"],
        user: json["user"],
        employee: json["employee"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "profile": profile,
        "profile_description": profileDescription,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "ci": ci,
        "names": names,
        "lastnames": lastnames,
        "email": email,
        "phone": phone,
        "address": address,
        "status": status,
        "user": user,
        "employee": employee,
      };

  Employee copy() => Employee(
      id: id,
      username: username,
      password: password,
      profile: profile,
      profileDescription: profileDescription,
      created: created,
      modified: modified,
      ci: ci,
      names: names,
      lastnames: lastnames,
      email: email,
      phone: phone,
      address: address,
      status: status,
      user: user,
      employee: employee);
}
