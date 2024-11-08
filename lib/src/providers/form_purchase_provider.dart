import 'package:facturacion/src/models/models.dart' show Purchase;
import 'package:flutter/material.dart';

class PurchaseFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Purchase purchase;
  bool isLoading = false;

  PurchaseFormProvider(this.purchase);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
