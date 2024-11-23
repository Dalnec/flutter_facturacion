import 'dart:convert';

class Ticket {
  Header header;
  Body body;
  List<Detail> details;

  Ticket({
    required this.header,
    required this.body,
    required this.details,
  });

  factory Ticket.fromRawJson(String str) => Ticket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        header: Header.fromJson(json["header"]),
        body: Body.fromJson(json["body"]),
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "body": body.toJson(),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Body {
  String previousReading;
  String actualReading;
  String price;
  String total;
  String subtotal;
  String previousMonth;
  String actualMonth;
  String consumed;

  Body({
    required this.previousReading,
    required this.actualReading,
    required this.price,
    required this.total,
    required this.subtotal,
    required this.previousMonth,
    required this.actualMonth,
    required this.consumed,
  });

  factory Body.fromRawJson(String str) => Body.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        previousReading: json["previous_reading"],
        actualReading: json["actual_reading"],
        price: json["price"],
        total: json["total"],
        subtotal: json["subtotal"],
        previousMonth: json["previous_month"],
        actualMonth: json["actual_month"],
        consumed: json["consumed"],
      );

  Map<String, dynamic> toJson() => {
        "previous_reading": previousReading,
        "actual_reading": actualReading,
        "price": price,
        "total": total,
        "subtotal": subtotal,
        "previous_month": previousMonth,
        "actual_month": actualMonth,
        "consumed": consumed,
      };
}

class Detail {
  String description;
  String price;
  String quantity;
  String subtotal;
  bool isIncome;

  Detail({
    required this.description,
    required this.price,
    required this.quantity,
    required this.subtotal,
    required this.isIncome,
  });

  factory Detail.fromRawJson(String str) => Detail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        description: json["description"],
        price: json["price"],
        quantity: json["quantity"],
        subtotal: json["subtotal"],
        isIncome: json["is_income"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "price": price,
        "quantity": quantity,
        "subtotal": subtotal,
        "is_income": isIncome,
      };
}

class Header {
  String number;
  String emissionDate;
  String medidor;
  String fullName;
  String address;

  Header({
    required this.number,
    required this.emissionDate,
    required this.medidor,
    required this.fullName,
    required this.address,
  });

  factory Header.fromRawJson(String str) => Header.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        number: json["number"],
        emissionDate: json["emission_date"],
        medidor: json["medidor"],
        fullName: json["full_name"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "emission_date": emissionDate,
        "medidor": medidor,
        "full_name": fullName,
        "address": address,
      };
}
