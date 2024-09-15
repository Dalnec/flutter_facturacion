import 'package:flutter/material.dart';
import 'package:facturacion/src/widgets/widgets.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facturación"),
      ),
      body: const Stack(
        children: [
          //Background
          Background(),
          //HomeBody
          _HomeBody(),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          // PageTitle(),
          // Cards
          CardTable()
        ],
      ),
    );
  }
}
