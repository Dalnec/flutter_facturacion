import 'package:facturacion/src/providers/form_purchase_provider.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/widgets/custom_input_field.dart';

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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulario de Usuario'),
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
                              'Datos de Compra:',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // InputDatePickerFormField(
                        //   keyboardType: TextInputType.datetime,
                        //   initialDate: DateTime.now(),
                        //   firstDate: DateTime(1900),
                        //   lastDate: DateTime(2100),
                        //   fieldLabelText: 'Fecha de Compra',
                        //   fieldHintText: 'Fecha de Compra',
                        //   onDateSaved: (value) =>
                        //       purchase.purchasedDate = value.toIso8601String(),
                        // ),
                        TextField(
                          controller: _dateController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de Compra',
                            helperText: 'Fecha',
                            prefixIcon: Icon(Icons.calendar_today,
                                color: AppTheme.primary),
                          ),
                          onTap: () async {
                            final actualDate = DateTime.now();
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: actualDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(actualDate.year,
                                  actualDate.month, actualDate.day),
                            );
                            if (pickedDate != null) {
                              // _dateController.text =
                              //     pickedDate.toIso8601String();
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomInputField(
                          labelText: 'Precio',
                          helperText: 'Ingresar Precio',
                          prefixIcon: Icons.price_change_outlined,
                          formProperty: 'price',
                          initialValue: purchase.price,
                          onChanged: (value) => purchase.price = value,
                          length: 7,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Litros',
                          helperText: 'Ingresar Litros',
                          prefixIcon: Icons.water_drop_outlined,
                          formProperty: 'liters',
                          initialValue: purchase.liters,
                          onChanged: (value) => purchase.liters = value,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Total',
                          helperText: 'Total de compra',
                          prefixIcon: Icons.monetization_on_outlined,
                          formProperty: 'total',
                          initialValue: purchase.total,
                          onChanged: (value) => purchase.total = value,
                        ),
                        const SizedBox(height: 10),
                        CustomInputField(
                          labelText: 'Observaciones',
                          helperText: '',
                          prefixIcon: Icons.comment_outlined,
                          formProperty: 'observations',
                          initialValue: purchase.observations,
                          onChanged: (value) => purchase.observations = value,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: Text("Guardar",
                              style: TextStyle(color: Colors.white)))),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!purchaseForm.isValidForm()) {
                      print('Formulario no válido');
                      return;
                    }
                    print('Formulario válido PURCHASE! Wiiii!');
                    // await purchaseService.saveOrCreateUsuario(usuario);
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   'user',
                    //   (route) => route.isFirst,
                    // );
                  },
                )
              ],
            ),
          ),
        )));
  }
}
