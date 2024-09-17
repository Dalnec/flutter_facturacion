import 'package:flutter/material.dart';
import 'package:facturacion/src/widgets/widgets.dart';

class InvoiceScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, String> formValues = {
    'measure': '0',
  };
  InvoiceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar Factura"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para la búsqueda
            Row(
              children: [
                Expanded(
                  child: TextField(
                    // controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Llamar a la función de búsqueda cuando se presione el ícono
                          // _search(_searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      // Llamar a la función de búsqueda cuando se presione Enter en el teclado
                      // _search(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              // ListView para mostrar los resultados
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const UserCardInvoiceInfo(hasDebt: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
