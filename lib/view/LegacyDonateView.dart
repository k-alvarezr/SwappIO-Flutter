import 'package:flutter/material.dart';
import 'shared/BottomNavView.dart';

class LegacyDonateView extends StatelessWidget {
  const LegacyDonateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donate")),
      body: const Center(child: Text("Donate Screen")),
      bottomNavigationBar: const BottomNavView(index: 1),
    );
  }
}



