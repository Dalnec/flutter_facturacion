// import 'dart:ui';

import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/monitoring/water_tank_level.dart';
import 'package:flutter/material.dart';

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
          // appBar: AppBar(
          //   title: const Text(
          //     'My Profile',
          //   ),
          //   centerTitle: true,
          //   backgroundColor: Colors.grey[700],
          //   elevation: 0,
          //   // give the app bar rounded corners
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(20.0),
          //       bottomRight: Radius.circular(20.0),
          //     ),
          //   ),
          //   leading: const Icon(
          //     Icons.menu,
          //   ),
          // ),
          body: NestedScrollView(
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
                  //           // first tab bar view widget
                  Container(
                    // color: Colors.red,
                    child: const Center(
                      child: Text(
                        'Bike',
                      ),
                    ),
                  ),

                  // second tab bar viiew widget
                  Container(
                    // color: Colors.pink,
                    child: const Center(
                      child: Text(
                        'Car',
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.pink,
                    child: const Center(
                      child: Text(
                        'Motorbike',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          // body: Column(
          //   children: <Widget>[
          //     // construct the profile details widget here
          //     const SizedBox(
          //       height: 270,
          //       child: WaterTankLevel(),
          //     ),

          //     SizedBox(
          //       height: 50,
          //       child: AppBar(
          //         backgroundColor: Colors.white,
          //         bottom: const TabBar(
          //           indicatorColor: AppTheme.primary,
          //           indicatorWeight: 4,
          //           tabs: [
          //             Tab(
          //               child: Text(
          //                 "Semanal",
          //                 style: TextStyle(color: AppTheme.primary),
          //               ),
          //             ),
          //             Tab(
          //               child: Text(
          //                 "Mensual",
          //                 style: TextStyle(color: AppTheme.primary),
          //               ),
          //             ),
          //             Tab(
          //               child: Text(
          //                 "Anual",
          //                 style: TextStyle(color: AppTheme.primary),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),

          //     // create widgets for each tab bar here
          //     Expanded(
          //       child: TabBarView(
          //         children: [
          //           // first tab bar view widget
          //           SingleChildScrollView(
          //             child: Container(
          //               // color: Colors.red,
          //               child: const Center(
          //                 child: Text(
          //                   'Bike',
          //                 ),
          //               ),
          //             ),
          //           ),

          //           // second tab bar viiew widget
          //           Container(
          //             // color: Colors.pink,
          //             child: const Center(
          //               child: Text(
          //                 'Car',
          //               ),
          //             ),
          //           ),
          //           Container(
          //             // color: Colors.pink,
          //             child: const Center(
          //               child: Text(
          //                 'Motorbike',
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
