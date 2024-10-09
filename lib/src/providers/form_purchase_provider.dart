import 'package:facturacion/src/models/models.dart' show Purchase;
import 'package:flutter/material.dart';

class PurchaseFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Purchase purchase;

  PurchaseFormProvider(this.purchase);

  // updateAvailability(bool value) {
  //   print(value);
  //   Purchase.available = value;
  //   notifyListeners();
  // }

  bool isValidForm() {
    print(purchase.purchasedDate);
    print(purchase.total);
    print(purchase.liters);
    print(purchase.price);
    return formKey.currentState?.validate() ?? false;
  }
}
