import 'dart:convert';

class Ticket {
  Header header;
  Body body;

  Ticket({
    required this.header,
    required this.body,
  });

  factory Ticket.fromRawJson(String str) => Ticket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        header: Header.fromJson(json["header"]),
        body: Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "body": body.toJson(),
      };
}

class Body {
  String previousReading;
  String actualReading;
  String previousMonth;
  String actualMonth;
  String price;
  String total;
  String consumed;

  Body({
    required this.previousReading,
    required this.actualReading,
    required this.previousMonth,
    required this.actualMonth,
    required this.price,
    required this.total,
    required this.consumed,
  });

  factory Body.fromRawJson(String str) => Body.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        previousReading: json["previous_reading"],
        actualReading: json["actual_reading"],
        previousMonth: json["previous_month"],
        actualMonth: json["actual_month"],
        price: json["price"],
        total: json["total"],
        consumed: json["consumed"],
      );

  Map<String, dynamic> toJson() => {
        "previous_reading": previousReading,
        "actual_reading": actualReading,
        "previous_month": previousMonth,
        "actual_month": actualMonth,
        "price": price,
        "total": total,
        "consumed": consumed,
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
