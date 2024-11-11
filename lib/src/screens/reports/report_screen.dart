import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

class ReporteScreen extends StatelessWidget {
  const ReporteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> estados = ['Estado 1', 'Estado 2', 'Estado 3'];
    List<String> meses = ['Mes 1', 'Mes 2', 'Mes 3'];
    List<String> anios = ['Año 1', 'Año 2', 'Año 3'];

    return Scaffold(
        appBar: AppBar(title: const Text('Reportes')),
        body: Padding(
          key: const Key('card_report'),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            width: double.infinity,
            decoration: _createCardShape(),
            child: Column(
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
                  items: estados.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // acción al seleccionar estado
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  hint: Text("Seleccionar Mes"),
                  items: meses.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // acción al seleccionar mes
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  hint: Text("Seleccionar Año"),
                  items: anios.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // acción al seleccionar año
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
                      onPressed: () {
                        // acción para aplicar filtros
                      },
                      child: Text("Descargar",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ));
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      );
}
