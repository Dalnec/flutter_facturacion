import 'package:facturacion/src/screens/monitoring/monitoring_settings_form_screen.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/widgets/paginated_datatable.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/monitoring/water_tank_level.dart';
import 'package:provider/provider.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Monitoreo"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
                final districService =
                    Provider.of<DistricService>(context, listen: false);
                await districService.getSettings();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MonitoringSettingsFormScreen()),
                );
                setState(() {});
              },
            )
          ],
        ),
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(child: WaterTankLevel()),
              const SliverToBoxAdapter(
                child: TabBar(
                  // controller: _controller,
                  tabs: [
                    Tab(
                      child: Text(
                        "Datos",
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Gráfico",
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
                    // Tab(
                    //   child: Text(
                    //     "Mensual",
                    //     style: TextStyle(color: AppTheme.primary),
                    //   ),
                    // ),
                    // Tab(
                    //   child: Text(
                    //     "Anual",
                    //     style: TextStyle(color: AppTheme.primary),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ];
          },
          body: Container(
            child: TabBarView(
              // controller: _controller,
              children: [
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: InfiniteScrollDataTable(),
                ),
                Container(
                  child: SingleChildScrollView(child: LineChartMonitoring()),
                ),
                // Container(
                //   child: const Center(
                //     child: Text(
                //       'Car',
                //     ),
                //   ),
                // ),
                // Container(
                //   child: const Center(
                //     child: Text(
                //       'Motorbike',
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
