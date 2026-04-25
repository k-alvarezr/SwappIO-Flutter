import 'package:flutter/material.dart';

class GradientScaffoldView extends StatelessWidget {
  const GradientScaffoldView({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
              Color(0xFF80DEEA),
            ],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}


