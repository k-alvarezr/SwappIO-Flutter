import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../core/constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/swapio_bottom_nav.dart';
import '../shared/widgets/activity_option_card.dart';
import '../shared/widgets/glass_panel.dart';
import '../shared/widgets/gradient_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = AppServices.instance.userRepository;
    final authRepository = AppServices.instance.authRepository;

    return FutureBuilder(
      future: userRepository.getCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data!;
        return GradientScaffold(
          bottomNavigationBar: const SwapioBottomNav(currentRoute: AppRoutes.profile),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
            child: Column(
              children: [
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_rounded)),
                const Expanded(
                  child: Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
                IconButton(
                  onPressed: () async {
                    await authRepository.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GlassPanel(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.name.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.location} • Member',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  const Divider(height: 30),
                  const Text(
                    'CURRENT BALANCE',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${user.balance.toStringAsFixed(0)} COP',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () {}, child: const Text('Withdraw')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            ActivityOptionCard(
              title: 'My Purchases',
              subtitle: '${user.purchases.length} active orders',
              icon: Icons.shopping_bag_rounded,
              iconColor: AppColors.primary,
              iconBackground: AppColors.primary.withOpacity(0.1),
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.purchases),
            ),
            const SizedBox(height: 12),
            ActivityOptionCard(
              title: 'My Listings',
              subtitle: '${user.listings.length} items for sale',
              icon: Icons.storefront_rounded,
              iconColor: const Color(0xFFEA580C),
              iconBackground: const Color(0x1AEA580C),
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.listings),
            ),
            const SizedBox(height: 12),
            ActivityOptionCard(
              title: 'Favorites',
              subtitle: '${user.favorites.length} saved items',
              icon: Icons.favorite_rounded,
              iconColor: const Color(0xFFE11D48),
              iconBackground: const Color(0x1AE11D48),
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.favorites),
            ),
              ],
            ),
          ),
        );
      },
    );
  }
}
