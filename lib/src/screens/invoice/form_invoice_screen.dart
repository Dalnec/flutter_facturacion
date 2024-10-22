import 'package:facturacion/src/providers/bottom_navigation_bar_provider.dart';
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
    final uiProvider = Provider.of<BottomNavigationProvider>(context);
    final invoice = invoiceService.selectedInvoice;
    final usuario = usuarioService.selectedUsuario;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información de Factura"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CardInfoUserInvoice(
                usuario: usuarioService.selectedUsuario,
              ),
              const SizedBox(height: 10),
              const Text(
                'Nueva Lectura',
                style: TextStyle(fontSize: 20),
              ),
              if (!usuario.makeInvoice)
                const Text("Usuario ya cuenta con recibo del Mes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.success,
                    )),
              const SizedBox(height: 5),
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
                    enabled: usuario.makeInvoice,
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
                onPressed: !usuario.makeInvoice
                    ? null
                    : () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!formKey.currentState!.validate()) {
                          print('Formulario no válido');
                          return;
                        }
                        final String formattedDate =
                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(DateTime.now());
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                final newInvoice = await invoiceService
                                    .saveOrCreateInvoice(invoice);
                                if (newInvoice != null) {
                                  invoice.measured = '';
                                  usuarioService
                                      .changeStatus(newInvoice.usuario);
                                  Navigator.of(context).pop();
                                  // Navigator.pushNamedAndRemoveUntil(
                                  //   context,
                                  //   'invoice',
                                  //   (route) => route.isFirst,
                                  // );
                                  uiProvider.selectedMenuOpt = 0;
                                }
                              },
                              child: const Text('Confirmar',
                                  style: TextStyle(color: AppTheme.harp)),
                            ),
                          ],
                        );
                      },
                child: const SizedBox(
                    width: double.infinity,
                    child: Center(
                        child: Text("Guardar",
                            style: TextStyle(color: Colors.white)))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
