import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class ListItemScreen extends StatelessWidget {
  const ListItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Item")),
      body: const Center(child: Text("Form here")),
      bottomNavigationBar: const CustomBottomNav(index: 2),
    );
  }
}
