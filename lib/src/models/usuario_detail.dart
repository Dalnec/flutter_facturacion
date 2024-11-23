import 'dart:convert';
import 'package:intl/intl.dart';

class UsuarioDetail {
  int? id;
  int? invoiceNumber;
  String? invoiceStatus;
  DateTime? created;
  DateTime? modified;
  String description;
  String price;
  String quantity;
  String? subtotal;
  bool isIncome;
  bool? status;
  int usuario;
  int? invoice;

  UsuarioDetail({
    this.id,
    this.invoiceNumber,
    this.invoiceStatus,
    this.created,
    this.modified,
    required this.description,
    required this.price,
    required this.quantity,
    this.subtotal,
    required this.isIncome,
    this.status,
    required this.usuario,
    this.invoice,
  });

  String formatedUsuarioDetailDate() {
    // Parsear la cadena de fecha al objeto DateTime
    DateTime parsedDate = created!;

    // Formatear la fecha al formato deseado
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);

    return formattedDate;
  }

  factory UsuarioDetail.fromRawJson(String str) =>
      UsuarioDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UsuarioDetail.fromJson(Map<String, dynamic> json) => UsuarioDetail(
        id: json["id"],
        invoiceNumber: json["invoice_number"],
        invoiceStatus: json["invoice_status"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        description: json["description"],
        price: json["price"],
        quantity: json["quantity"],
        subtotal: json["subtotal"],
        isIncome: json["is_income"],
        status: json["status"],
        usuario: json["usuario"],
        invoice: json["invoice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_number": invoiceNumber,
        "invoice_status": invoiceStatus,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "description": description,
        "price": price,
        "quantity": quantity,
        "subtotal": subtotal,
        "is_income": isIncome,
        "status": status,
        "usuario": usuario,
        "invoice": invoice,
      };

  copy() {
    return UsuarioDetail(
      id: id,
      invoiceNumber: invoiceNumber,
      invoiceStatus: invoiceStatus,
      created: created,
      modified: modified,
      description: description,
      price: price,
      quantity: quantity,
      subtotal: subtotal,
      isIncome: isIncome,
      status: status,
      usuario: usuario,
      invoice: invoice,
    );
  }
}
