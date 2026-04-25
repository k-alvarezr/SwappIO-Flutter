import 'package:flutter/material.dart';
import 'shared/BottomNavView.dart';
import 'ProductCardWidgetView.dart';

class LegacyHomeView extends StatelessWidget {
  const LegacyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: const [
          ProductCardWidgetView("Dress", "\$45.000"),
          ProductCardWidgetView("Jacket", "\$120.000"),
        ],
      ),
      bottomNavigationBar: const BottomNavView(index: 0),
    );
  }
}



