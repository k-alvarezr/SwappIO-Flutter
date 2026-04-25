import 'package:flutter/material.dart';
import 'shared/BottomNavView.dart';

class ListItemView extends StatelessWidget {
  const ListItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Item")),
      body: const Center(child: Text("Form here")),
      bottomNavigationBar: const BottomNavView(index: 2),
    );
  }
}



