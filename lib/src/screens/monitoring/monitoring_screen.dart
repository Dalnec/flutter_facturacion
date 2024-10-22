import 'package:facturacion/src/widgets/paginated_datatable.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/monitoring/water_tank_level.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Monitoreo"),
        ),
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              const SliverToBoxAdapter(child: WaterTankLevel()),
              const SliverToBoxAdapter(
                child: TabBar(
                  // controller: _controller,
                  tabs: [
                    Tab(
                      child: Text(
                        "Semanal",
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Mensual",
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Anual",
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
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
                  padding: EdgeInsets.all(8.0),
                  child: InfiniteScrollDataTable(),
                ),
                Container(
                  child: const Center(
                    child: Text(
                      'Car',
                    ),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Text(
                      'Motorbike',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
