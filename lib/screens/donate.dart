import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donate")),
      body: const Center(child: Text("Donate Screen")),
      bottomNavigationBar: const CustomBottomNav(index: 1),
    );
  }
}
