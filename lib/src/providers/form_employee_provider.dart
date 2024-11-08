import 'package:facturacion/src/models/models.dart' show Employee;
import 'package:flutter/material.dart';

class EmployeeFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Employee employee;
  bool isLoading = false;

  EmployeeFormProvider(this.employee);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
