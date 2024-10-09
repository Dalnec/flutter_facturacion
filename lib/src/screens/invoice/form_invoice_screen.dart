import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormInvoiceScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FormInvoiceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);
    final invoiceService = Provider.of<InvoiceService>(context);
    final invoice = invoiceService.selectedInvoice;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar Factura"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Informacion de Usuario',
                style: TextStyle(fontSize: 20),
              ),
              UserCardInfo(
                showActions: false,
                usuario: usuarioService.selectedUsuario,
                service: usuarioService,
              ),
              const SizedBox(height: 10),
              const Text(
                'Nueva Lectura',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15, // soften the shadow
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: CustomInputField(
                    labelText: 'Nuevo Valor',
                    helperText: 'Ingresar Lectura',
                    prefixIcon: Icons.add_chart,
                    formProperty: 'measure',
                    initialValue: invoice.measured.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    onChanged: (value) => invoice.measured = value,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const SizedBox(
                    width: double.infinity,
                    child: Center(
                        child: Text("Guardar",
                            style: TextStyle(color: Colors.white)))),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!formKey.currentState!.validate()) {
                    print('Formulario no válido');
                    return;
                  }
                  final String formattedDate =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                  invoice.readDate = formattedDate;
                  invoice.price = '0.35';
                  final total = double.parse(invoice.measured) *
                      double.parse(invoice.price);
                  invoice.total = total.toStringAsFixed(2);
                  print(invoice.toJson());

                  ModularDialog.showModularDialog(
                    context: context,
                    title: 'Registrar Lectura',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('¿Está seguro de guardar este valor?'),
                        Text(
                          'VALOR LECTURA: ${invoice.measured}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Navigator.of(context).pop();
                          final newInvoice =
                              await invoiceService.saveOrCreateInvoice(invoice);
                          if (newInvoice != null) {
                            usuarioService.changeStatus(newInvoice.usuario);
                            Navigator.of(context).pop();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              'invoice',
                              (route) => route.isFirst,
                            );
                          }
                        },
                        child: const Text('Confirmar',
                            style: TextStyle(color: AppTheme.harp)),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
