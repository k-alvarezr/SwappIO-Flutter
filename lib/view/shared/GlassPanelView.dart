import 'package:flutter/material.dart';

import 'AppColorsView.dart';

class GlassPanelView extends StatelessWidget {
  const GlassPanelView({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColorsView.surfaceGlass,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(0.45)),
      ),
      child: child,
    );
  }
}




