import 'package:facturacion/src/models/models.dart' show Usuario;
import 'package:flutter/material.dart';

class UsuarioFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Usuario usuario;

  UsuarioFormProvider(this.usuario);

  // updateAvailability(bool value) {
  //   print(value);
  //   usuario.available = value;
  //   notifyListeners();
  // }

  bool isValidForm() {
    print(usuario.names);
    print(usuario.lastnames);
    print(usuario.status);
    return formKey.currentState?.validate() ?? false;
  }
}
