import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      bottomNavigationBar: const CustomBottomNav(index: 4),
    );
  }
}
