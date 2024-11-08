import 'package:facturacion/src/models/models.dart' show Settings;
import 'package:flutter/material.dart';

class SettingsFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Settings settings;
  bool isLoading = false;
  String timerInterval = 'min';

  SettingsFormProvider(this.settings);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setTimerInterval(String value) {
    timerInterval = value;
    notifyListeners();
  }
}
