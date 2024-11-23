import 'package:facturacion/src/models/models.dart' show UsuarioDetail;
import 'package:flutter/material.dart';

class UsuarioDetailFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UsuarioDetail usuarioDetail;
  bool isLoading = false;

  UsuarioDetailFormProvider(this.usuarioDetail);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
