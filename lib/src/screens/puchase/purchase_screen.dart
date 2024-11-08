import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/screens/puchase/purchase_form_screen.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart'
    show LineChartWidget, PurchaseDataTable;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  List<Purchase> _data = [];
  bool _isLoading = false;
  int? selectedYear;
  List<int> years = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 2022; i--) {
      years.add(i);
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final purchaseService =
        Provider.of<PurchaseService>(context, listen: false);
    await purchaseService.getPurchases('', selectedYear ?? 2024, 12, 1, '-id');
    _data = purchaseService.purchases;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final purchaseService =
        Provider.of<PurchaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifas'),
        actions: [
          IconButton(
              onPressed: () async {
                purchaseService.selectedPurchase = Purchase(
                  purchasedDate: "",
                  total: "0",
                  liters: "0",
                  price: "",
                  employee: 0,
                  employeeName: "",
                  observations: "",
                  active: true,
                );
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PurchaseFormScreen()),
                );
                if (result != null && result == 'reload') {
                  setState(() {
                    print("Datos recargados");
                    _fetchData();
                  });
                }
              },
              icon: const Icon(Icons.add_outlined, color: Colors.white))
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    textAlign: TextAlign.center,
                    "Últimas Tarifas:",
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 20,
                    )),
                Center(
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
                          style: const TextStyle(
                              fontSize: 16, color: AppTheme.primary),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedYear = newValue;
                        _fetchData();
                        print("Selector: $selectedYear");
                      });
                    },
                  ),
                )
              ],
            )),
            SliverToBoxAdapter(
              child: _isLoading
                  ? _CardContainer(
                      height: 230,
                      child: Center(child: const CircularProgressIndicator()))
                  : Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _CardContainer(
                        height: 230,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: LineChartWidget(
                            minX: 0,
                            maxX: 11,
                            minY: 0,
                            maxY: 6,
                            spots: _data.reversed
                                .map((e) => FlSpot(
                                      double.parse('${e.getMonth()}'),
                                      // double.parse('${e.id}'),
                                      double.parse(e.price),
                                    ))
                                .toList(),
                            bottomTitleWidgets: _bottomTitleWidgets,
                            leftTitleWidgets: _leftTitleWidgets,
                          ),
                        ),
                      ),
                    ),
            )
          ];
        },
        body: PurchaseDataTable(
          year: selectedYear,
          reload: _isLoading,
        ),
      ),
    );
  }
}

Widget _bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
  String text;
  switch (value.toInt()) {
    // switch (value.toInt() % 12) {
    case 0:
      text = 'Ene';
    case 1:
      text = 'Feb';
    case 2:
      text = 'Mar';
    case 3:
      text = 'Abr';
    case 4:
      text = 'May';
    case 5:
      text = 'Jun';
    case 6:
      text = 'Jul';
    case 7:
      text = 'Ago';
    case 8:
      text = 'Sep';
    case 9:
      text = 'Oct';
    case 10:
      text = 'Nov';
    case 11:
      text = 'Dec';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(text, style: style),
  );
}

Widget _leftTitleWidgets(double value, TitleMeta meta) {
  if (value == meta.max) {
    return Container();
  }
  const style = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      meta.formattedValue,
      style: style,
    ),
  );
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  final double? height;

  const _CardContainer({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      // width: 300,
      height: height ?? null,
      decoration: _createCardShape(),
      child: child,
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      );
}
