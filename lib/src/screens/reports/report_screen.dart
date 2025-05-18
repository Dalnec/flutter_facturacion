import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

// class PdfDownloader {
//   Future<void> requestPermissions() async {
//     if (await Permission.storage.request().isGranted) {
//       print("Storage permission granted.");
//     } else {
//       print("Storage permission denied.");
//     }
//   }

//   static Future<void> downloadPdf(
//       String url, String filename, Map<String, dynamic>? params) async {
//     final taskId = await FlutterDownloader.enqueue(
//       url: url,
//       savedDir: '/storage/emulated/0/Download',
//       fileName: '$filename.pdf',
//       showNotification: true, // <--- muestra notificación automática
//       openFileFromNotification: true, // <--- abrir desde la notificación
//     );
//     print("Download started with Task ID: $taskId");
//   }
// }

// class PdfDownloader {
//   static Future<String?> downloadPdf(
//       String url, String filename, Map<String, dynamic>? params) async {
//     final path = '/storage/emulated/0/Download/$filename.pdf';

//     try {
//       final response = await Dio().get(
//         url,
//         queryParameters: params,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,
//           validateStatus: (status) => status! < 500,
//         ),
//       );

//       final file = File(path);
//       await file.writeAsBytes(response.data);

//       return path;
//     } catch (e) {
//       print('Error al descargar el PDF: $e');
//       return null;
//     }
//   }
// }
// class PdfDownloader {
//   static Future<bool> downloadPdf({
//     required BuildContext context,
//     required String url,
//     required String filename,
//     Map<String, dynamic>? params,
//   }) async {
//     // Primero, pedir permiso de almacenamiento
//     final status = await Permission.storage.request();

//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Permiso de almacenamiento denegado')),
//       );
//       return false;
//     }

//     try {
//       await FlutterDownloader.enqueue(
//         url: url,
//         savedDir: '/storage/emulated/0/Download',
//         fileName: filename,
//         showNotification: true,
//         openFileFromNotification: true,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Descarga iniciada correctamente')),
//       );
//       return true;
//     } catch (e) {
//       print('Error al iniciar descarga: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error al iniciar descarga')),
//       );
//       return false;
//     }
//   }
// }
class PdfDownloader {
  String buildUrlWithParams(String baseUrl, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return baseUrl;

    final queryString = params.entries.map((e) {
      final key = Uri.encodeComponent(e.key);
      final value = Uri.encodeComponent(e.value.toString());
      return '$key=$value';
    }).join('&');

    return '$baseUrl?$queryString';
  }

  static Future<bool> downloadPdf({
    required BuildContext context,
    required String url,
    required String filename,
    Map<String, dynamic>? params,
  }) async {
    // Pedir permisos según versión de Android
    bool permissionGranted = await _requestPermissions();

    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de almacenamiento denegado')),
      );
      return false;
    }

    final newUrl = PdfDownloader().buildUrlWithParams(url, params);

    try {
      await FlutterDownloader.enqueue(
        url: newUrl,
        savedDir: '/storage/emulated/0/Download',
        fileName: filename,
        showNotification: true,
        openFileFromNotification: true,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descarga iniciada correctamente')),
      );
      return true;
    } catch (e) {
      print('Error al iniciar descarga: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar descarga')),
      );
      return false;
    }
  }

  static Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      }

      // Para Android 11 o superior
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      // Para Android 10 o menor
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      return false;
    } else {
      // iOS no necesita permisos especiales para downloads
      return true;
    }
  }
}

class ReporteScreen extends StatefulWidget {
  const ReporteScreen({super.key});

  @override
  _ReporteScreenState createState() => _ReporteScreenState();
}

class _ReporteScreenState extends State<ReporteScreen> {
  bool _isDownloading = false;

  // void downloadPdf(url, filename, params) async {
  //   setState(() {
  //     _isDownloading = true;
  //   });

  //   // final path = await PdfDownloader.downloadPdf(url, filename, params);

  //   setState(() {
  //     _isDownloading = false;
  //   });

  //   // if (path != null) {
  //   //   print('PDF descargado correctamente en: $path');
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     const SnackBar(content: Text('Reporte descargado correctamente')),
  //   //   );
  //   // } else {
  //   //   print('Error al descargar el PDF');
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     const SnackBar(content: Text('Error al descargar el reporte :(')),
  //   //   );
  //   // }
  // }

  Future<void> downloadPdf(url, filename, params) async {
    setState(() => _isDownloading = true);

    await PdfDownloader.downloadPdf(
      context: context,
      url: url,
      filename: filename,
      params: params,
    );

    setState(() => _isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Descargar PDF'),
        ),
        body: Padding(
            key: const Key('card_report'),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(children: [
              _InvoiceReport(
                download: downloadPdf,
                isDownloading: _isDownloading,
              ),
              SizedBox(height: 20),
              _UsuariosReport(
                download: downloadPdf,
                isDownloading: _isDownloading,
              ),
            ])));
  }
}

class _ContainerWidget extends StatelessWidget {
  const _ContainerWidget({
    super.key,
    required this.widget,
  });

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        width: double.infinity,
        decoration: _createCardShape(),
        child: widget);
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      );
}

class _InvoiceReport extends StatelessWidget {
  final Function download;
  final bool isDownloading;

  _InvoiceReport({
    super.key,
    required this.download,
    required this.isDownloading,
  });

  final List<Map<String, String>> estados = [
    {'': 'TODOS'},
    {'P': 'AL DIA'},
    {'D': 'DEUDA'}
  ];
  final List<Map<String, String>> meses = [
    {'1': 'Enero'},
    {'2': 'Febrero'},
    {'3': 'Marzo'},
    {'4': 'Abril'},
    {'5': 'Mayo'},
    {'6': 'Junio'},
    {'7': 'Julio'},
    {'8': 'Agosto'},
    {'9': 'Septiembre'},
    {'10': 'Octubre'},
    {'11': 'Noviembre'},
    {'12': 'Diciembre'}
  ];

  List<String> _gerYears() {
    int currentYear = DateTime.now().year;
    List<String> anios = [];
    for (int i = currentYear; i >= 2022; i--) {
      anios.add(i.toString());
    }
    return anios;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> filters = {
      'status': '',
      'month': '${DateTime.now().month}',
      'year': '${DateTime.now().year}',
    };

    return _ContainerWidget(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Reporte Facturas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              )),
          Text("Filtrar por Estado, Mes y Año",
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primary,
              )),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            hint: Text("Seleccionar Estado"),
            items: estados.map((Map<String, String> estado) {
              String key = estado.keys.first;
              String value = estado[key]!;
              return DropdownMenuItem<String>(
                value: key,
                child: Text(value),
              );
            }).toList(),
            value: filters['status'],
            onChanged: (value) {
              filters['status'] = value!;
            },
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            hint: Text("Seleccionar Mes"),
            items: meses.map((Map<String, String> mes) {
              String key = mes.keys.first;
              String value = mes[key]!;
              return DropdownMenuItem<String>(
                value: key,
                child: Text(value),
              );
            }).toList(),
            value: filters['month'],
            onChanged: (value) {
              filters['month'] = value!;
            },
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            hint: Text("Seleccionar Año"),
            items: _gerYears().map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: filters['year'],
            onChanged: (value) {
              filters['year'] = value!;
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Cancelar'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: isDownloading
                    ? null
                    : () async {
                        download(
                          "https://barrioluzapi.tsifactur.com/api/invoice/status_report/",
                          "reporte_facturas_${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}.pdf",
                          filters,
                        );
                      },
                child: Text(isDownloading ? 'Descargando...' : 'Descargar',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _UsuariosReport extends StatelessWidget {
  final Function download;
  final bool isDownloading;

  _UsuariosReport({
    super.key,
    required this.download,
    required this.isDownloading,
  });

  @override
  Widget build(BuildContext context) {
    return _ContainerWidget(
        widget: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Reporte Usuarios",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            )),
        Text("Descargar Lista de Usuarios",
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
            )),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: isDownloading
                  ? null
                  : () async {
                      // final Uri url = Uri.parse(
                      //     "http://barrioluzapi.tsifactur.com/api/usuario/report/");
                      // if (!await launchUrl(url)) {
                      //   throw Exception('Could not launch $url');
                      // }
                      // download(
                      //   "http://barrioluzapi.tsifactur.com/api/usuario/report/",
                      //   "reporte_usuarios_${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}.pdf",
                      //   null,
                      // );
                      download(
                        "https://barrioluzapi.tsifactur.com/api/usuario/report/",
                        "reporte_usuarios_${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}.pdf",
                        null,
                      );
                    },
              child: Text(isDownloading ? 'Descargando...' : 'Descargar',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    ));
  }
}
