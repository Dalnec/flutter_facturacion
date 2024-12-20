import 'package:facturacion/src/models/models.dart' show Usuario;
import 'package:flutter/material.dart';

class UsuarioFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Usuario usuario;
  bool isLoading = false;

  UsuarioFormProvider(this.usuario);

  bool isValidForm() {
    print(usuario.names);
    print(usuario.lastnames);
    print(usuario.status);
    return formKey.currentState?.validate() ?? false;
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
