import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: const [
          ProductCard("Dress", "\$45.000"),
          ProductCard("Jacket", "\$120.000"),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(index: 0),
    );
  }
}
