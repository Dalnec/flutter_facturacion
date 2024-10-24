import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearSelector extends StatefulWidget {
  const YearSelector({super.key});

  @override
  _YearSelectorState createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  int? selectedYear;
  List<int> years = [];

  @override
  void initState() {
    super.initState();
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 2020; i--) {
      years.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceService = Provider.of<InvoiceService>(context, listen: false);
    return Center(
      child: DropdownButton<int>(
        isExpanded: false,
        dropdownColor: Colors.white,
        hint: Text(
          'Seleccionar Año',
          style: TextStyle(color: AppTheme.primary, fontSize: 14),
        ),
        value: selectedYear,
        items: years.map((year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text(
              year.toString(),
              style: const TextStyle(fontSize: 16, color: AppTheme.primary),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedYear = newValue;
            // invoiceService.testInvoice();
            invoiceService.selectedYear = newValue!;
            print("Selector: ${invoiceService.selectedYear}");
          });
        },
      ),
    );
  }
}
