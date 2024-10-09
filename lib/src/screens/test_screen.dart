import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista previa del Recibo')),
      body: Screenshot(
        controller: screenshotController,
        child: const _TestWidget(),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () => _launchUrl()
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image = await screenshotController
              .captureFromWidget(const _TestWidget(), pixelRatio: 2);
          Share.shareXFiles([
            XFile.fromData(image, name: 'recibo.png', mimeType: 'image/png')
          ]);
        },
        child: const Icon(Icons.camera),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://wa.me/59165351938?text=Hello');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }
}

class _TestWidget extends StatelessWidget {
  const _TestWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15, // soften the shadow
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('RECIBO N° 155',
              style: TextStyle(fontSize: 24, color: Colors.black)),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Fecha Emisión:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(width: 10),
              Text('01/10/2024',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Medidor:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(width: 10),
              Text('E365498',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Señor(a):',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(width: 10),
              Text('Maria Fernanda Martinez',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Domicilio:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(width: 10),
              Text('Calle Martin Otero 123',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
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
                  dataRowMaxHeight: 40,
                  columnSpacing: 18,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Anterior',
                      ),
                      // headingRowAlignment: MainAxisAlignment.center,
                    ),
                    DataColumn(
                      label: Text(
                        'Actual',
                      ),
                      // headingRowAlignment: MainAxisAlignment.center,
                    ),
                    DataColumn(
                      label: Text(
                        'Consumo',
                      ),
                      // headingRowAlignment: MainAxisAlignment.center,
                    ),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Column(
                        children: [
                          Text(
                            "AGO-2024",
                            // textAlign: TextAlign.center,
                          ),
                          Text(
                            "1235",
                            // textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      DataCell(Column(
                        children: [
                          Text(
                            "SEP-2024",
                            // textAlign: TextAlign.center,
                          ),
                          Text(
                            "1250",
                            // textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                      DataCell(Text(
                        "15",
                        // textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ])
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Concepto(s)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Servicio de Agua',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              // Expanded(
              //   child: Text(
              //     'Servicio de Agua',
              //     style: TextStyle(fontSize: 16),
              //   ),
              // ),
              // Expanded(
              //   child: Text(
              //     '15',
              //     style: TextStyle(fontSize: 16),
              //   ),
              // ),
              // Expanded(
              //   child: Text(
              //     '0.65',
              //     style: TextStyle(fontSize: 16),
              //   ),
              // ),
              Text(
                '9.75',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              // Expanded(
              //   child: Text(
              //     '9.75',
              //     style: TextStyle(fontSize: 16),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'TOTAL A PAGAR',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '9.75',
                style: TextStyle(
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
