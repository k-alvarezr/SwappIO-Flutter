import 'package:flutter/material.dart';
import 'shared/BottomNavView.dart';

class LegacyProfileView extends StatelessWidget {
  const LegacyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(radius: 50),
          const Text("Camila Rodriguez"),
        ],
      ),
      bottomNavigationBar: const BottomNavView(index: 4),
    );
  }
}



