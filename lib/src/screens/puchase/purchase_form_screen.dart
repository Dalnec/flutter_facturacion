import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/providers/form_purchase_provider.dart';
import 'package:facturacion/src/services/services.dart';

class PurchaseFormScreen extends StatelessWidget {
  const PurchaseFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final purchaseService = Provider.of<PurchaseService>(context);

    return ChangeNotifierProvider(
        create: (_) => PurchaseFormProvider(purchaseService.selectedPurchase),
        child: _PurchaseFormProviderBody(purchaseService: purchaseService));
  }
}

class _PurchaseFormProviderBody extends StatelessWidget {
  final TextEditingController _dateController = TextEditingController();
  final PurchaseService purchaseService;

  _PurchaseFormProviderBody({
    super.key,
    required this.purchaseService,
  });

  @override
  Widget build(BuildContext context) {
    final purchaseForm = Provider.of<PurchaseFormProvider>(context);
    final purchase = purchaseForm.purchase;
    bool isLoading = false;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Tarifas'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: purchaseForm.formKey,
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              // 'Datos de Compra:',
                              'Registrar Nueva Tarifa',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 10),
                        // TextField(
                        //   controller: _dateController,
                        //   keyboardType: TextInputType.datetime,
                        //   decoration: const InputDecoration(
                        //     labelText: 'Fecha de Compra',
                        //     helperText: 'Fecha',
                        //     prefixIcon: Icon(Icons.calendar_today,
                        //         color: AppTheme.primary),
                        //   ),
                        //   onTap: () async {
                        //     final actualDate = DateTime.now();
                        //     DateTime? pickedDate = await showDatePicker(
                        //       context: context,
                        //       initialDate: actualDate,
                        //       firstDate: DateTime(2020),
                        //       lastDate: DateTime(actualDate.year,
                        //           actualDate.month, actualDate.day),
                        //     );
                        //     if (pickedDate != null) {
                        //       // _dateController.text =
                        //       //     pickedDate.toIso8601String();
                        //       _dateController.text =
                        //           DateFormat('yyyy-MM-dd').format(pickedDate);
                        //     }
                        //   },
                        // ),
                        const SizedBox(height: 15),
                        CustomInputField(
                          labelText: 'Precio',
                          helperText: 'Ingresar Precio',
                          prefixIcon: Icons.price_change_outlined,
                          formProperty: 'price',
                          initialValue: purchase.price,
                          onChanged: (value) => purchase.price = value,
                          length: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                        ),
                        // const SizedBox(height: 10),
                        // CustomInputField(
                        //   labelText: 'Litros',
                        //   helperText: 'Ingresar Litros',
                        //   prefixIcon: Icons.water_drop_outlined,
                        //   formProperty: 'liters',
                        //   initialValue: purchase.liters,
                        //   onChanged: (value) => purchase.liters = value,
                        // ),
                        // const SizedBox(height: 10),
                        // CustomInputField(
                        //   labelText: 'Total',
                        //   helperText: 'Total de compra',
                        //   prefixIcon: Icons.monetization_on_outlined,
                        //   formProperty: 'total',
                        //   initialValue: purchase.total,
                        //   onChanged: (value) => purchase.total = value,
                        // ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Observaciones',
                          helperText: '',
                          prefixIcon: Icons.comment_outlined,
                          formProperty: 'observations',
                          initialValue: purchase.observations,
                          onChanged: (value) => purchase.observations = value,
                          length: 0,
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: purchaseForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (!purchaseForm.isValidForm()) {
                            print('Formulario no válido');
                            return;
                          }
                          ModularDialog.showModularDialog(
                            context: context,
                            title: 'Confirmar Acción',
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '¿Desea registrar esta tarifa?',
                                  style: TextStyle(fontSize: 16),
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
                                  purchaseForm.setLoading(true);
                                  Navigator.of(context).pop();
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  final resp = await purchaseService
                                      .saveOrCreatePurchase(purchase);
                                  // final resp = await purchaseService
                                  //     .createPurchase(purchase);
                                  purchaseForm.setLoading(false);
                                  if (!resp) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Error al realizar la acción')),
                                    );
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Acción realizada correctamente')),
                                  );
                                  Navigator.pop(context, 'reload');
                                },
                                child: const Text('Confirmar',
                                    style: TextStyle(color: AppTheme.harp)),
                              ),
                            ],
                          );
                        },
                  child: SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: purchaseForm.isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primary,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text("Guardar",
                                  style: TextStyle(color: Colors.white)))),
                )
              ],
            ),
          ),
        )));
  }
}
