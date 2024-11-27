import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:facturacion/src/models/models.dart' show Ticket;

class TicketFormat extends StatelessWidget {
  final String data;

  const TicketFormat({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final ticketData = Ticket.fromJson(json.decode(data));
    final header = ticketData.header;
    final body = ticketData.body;
    final details = ticketData.details;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('RECIBO N° ${header.number}',
              style: const TextStyle(fontSize: 24, color: Colors.black)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Fecha Emisión:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(width: 10),
              Text(header.emissionDate,
                  style: const TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Medidor:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(width: 10),
              //TODO: PREGUNTAR SI TIENE CODIGO DE MEDIDOR
              Text(header.medidor,
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Señor(a):',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  header.fullName,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Domicilio:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(header.address,
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Detalle de Lecturas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: DataTable(
                  headingRowHeight: 25,
                  dataRowMinHeight: 25,
                  dataRowMaxHeight: 65,
                  columnSpacing: 10,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Anterior',
                      ),
                      headingRowAlignment: MainAxisAlignment.center,
                    ),
                    DataColumn(
                      label: Text(
                        'Actual',
                      ),
                      headingRowAlignment: MainAxisAlignment.center,
                    ),
                    DataColumn(
                      label: Text(
                        'Consumo',
                      ),
                      headingRowAlignment: MainAxisAlignment.center,
                    ),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            body.previousMonth,
                          ),
                          Text(
                            body.previousReading,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      DataCell(Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            body.actualMonth,
                          ),
                          Text(
                            body.actualReading,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      DataCell(Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            body.consumed,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                    ])
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(height: 10),
          const Text(
            'Concepto(s)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Servicio de Agua',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                body.consumed,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                body.price,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                body.subtotal,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          ListView(
            shrinkWrap: true,
            children: [
              for (int i = 0; i < details.length; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      details[i].description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      details[i].quantity,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      details[i].price,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      details[i].subtotal,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'TOTAL A PAGAR',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${body.total} Bs.',
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
