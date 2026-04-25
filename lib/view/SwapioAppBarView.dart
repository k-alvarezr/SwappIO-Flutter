import 'package:flutter/material.dart';

import 'shared/AppColorsView.dart';

class SwapioAppBarView extends StatelessWidget implements PreferredSizeWidget {
  const SwapioAppBarView({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
    this.centerTitle = true,
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColorsView.textPrimary,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}




