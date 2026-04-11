import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../routes/app_routes.dart';

class SwapioBottomNav extends StatelessWidget {
  const SwapioBottomNav({
    super.key,
    required this.currentRoute,
  });

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      const _NavItem(route: AppRoutes.home, icon: Icons.home_rounded, label: 'Home'),
      const _NavItem(route: AppRoutes.donate, icon: Icons.favorite_rounded, label: 'Donate'),
      const _NavItem(route: AppRoutes.add, icon: Icons.add, label: 'Sell', isFab: true),
      const _NavItem(route: AppRoutes.chatList, icon: Icons.email_rounded, label: 'Inbox'),
      const _NavItem(route: AppRoutes.profile, icon: Icons.person_rounded, label: 'Profile'),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 84,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items.map((item) {
              final isSelected = currentRoute == item.route;
              if (item.isFab) {
                return FloatingActionButton(
                  heroTag: 'bottom-nav-fab',
                  onPressed: () => _go(context, item.route, isSelected),
                  backgroundColor: AppColors.primary,
                  shape: const CircleBorder(),
                  elevation: 0,
                  child: const Icon(Icons.add, color: Colors.white),
                );
              }
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _go(context, item.route, isSelected),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: isSelected ? AppColors.primary : Colors.black54),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? AppColors.primary : Colors.black54,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String route, bool isSelected) {
    if (isSelected) return;
    Navigator.of(context).pushReplacementNamed(route);
  }
}

class _NavItem {
  const _NavItem({
    required this.route,
    required this.icon,
    required this.label,
    this.isFab = false,
  });

  final String route;
  final IconData icon;
  final String label;
  final bool isFab;
}
