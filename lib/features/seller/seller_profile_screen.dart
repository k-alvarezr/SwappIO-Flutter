import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/app_user.dart';
import '../../data/models/product.dart';
import '../../routes/app_routes.dart';
import '../shared/widgets/product_card.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key, required this.sellerId});

  final String sellerId;

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  final _userRepository = AppServices.instance.userRepository;
  final _productRepository = AppServices.instance.productRepository;
  final _chatRepository = AppServices.instance.chatRepository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final seller = snapshot.data![0] as AppUser;
        final currentUser = snapshot.data![1] as AppUser;
        final products = snapshot.data![2] as List<Product>;
        final isFollowing = currentUser.following.contains(seller.id);
        return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
                    const Expanded(
                      child: Text(
                        'Seller Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
                  ],
                ),
                const SizedBox(height: 18),
                CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.white,
                  child: Text(
                    seller.name.substring(0, 1),
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(seller.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Top Seller',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(seller.location, style: const TextStyle(color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await _userRepository.toggleFollow(seller.id);
                          if (mounted) setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFollowing ? Colors.grey : AppColors.primary,
                        ),
                        icon: Icon(isFollowing ? Icons.check_rounded : Icons.add_rounded),
                        label: Text(isFollowing ? 'Following' : 'Follow'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          if (products.isEmpty) return;
                          final chatId = await _chatRepository.startChatForProduct(products.first.id);
                          Navigator.of(context).pushNamed(AppRoutes.chatDetail, arguments: chatId);
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded),
                        label: const Text('Message'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _StatCard(label: 'Sold', value: seller.soldCount.toString())),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(label: 'Active', value: products.length.toString())),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(label: 'Rating', value: seller.rating.toStringAsFixed(1), icon: Icons.star_rounded)),
                  ],
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Active Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final isFavorite = currentUser.favorites.contains(product.id);
                      return ProductCard(
                        product: product,
                        isFavorite: isFavorite,
                        onFavoriteTap: () async {
                          await _userRepository.toggleFavorite(product.id);
                          if (mounted) setState(() {});
                        },
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.productDetail, arguments: product.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        );
      },
    );
  }

  Future<List<Object>> _loadData() async {
    final seller = await _userRepository.getUserById(widget.sellerId);
    final currentUser = await _userRepository.getCurrentUser();
    final products = await _productRepository.getProductsForUser(seller.id);
    return [seller, currentUser, products];
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.45)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 18, color: const Color(0xFFFFC107)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
