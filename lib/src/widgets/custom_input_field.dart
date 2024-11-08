import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool? enabled;
  final int? length;
  final int? maxLines;

  final String? initialValue;
  final String formProperty;
  final Map<String, String>? formValues;
  final Function? onChanged;
  final Function? validator;
  final List<FilteringTextInputFormatter>? inputFormatters;

  const CustomInputField({
    super.key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    required this.formProperty,
    this.formValues,
    this.initialValue,
    this.length = 3,
    this.maxLines = 1,
    this.onChanged,
    this.inputFormatters,
    this.enabled,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      autofocus: false,
      maxLines: maxLines,
      initialValue: initialValue,
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: (initialValue == null)
          ? (value) => formValues![formProperty] = value
          : (value) => onChanged!(value),
      validator: (length != 0)
          ? (value) {
              if (value == null) return 'Campo requerido';
              return value.length < length!
                  ? 'Debe ser mayor a $length caracteres'
                  : null;
            }
          : null,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        // counterText: '3 characters',
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: AppTheme.primary),
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
        icon: icon == null ? null : Icon(icon),
      ),
    );
  }
}
