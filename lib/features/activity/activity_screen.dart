import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../data/models/app_user.dart';
import '../../data/models/product.dart';
import '../../routes/app_routes.dart';
import '../shared/widgets/gradient_scaffold.dart';
import '../shared/widgets/product_card.dart';

enum ActivityType { purchases, listings, favorites }

class ActivityScreenArgs {
  const ActivityScreenArgs({
    required this.title,
    required this.type,
  });

  final String title;
  final ActivityType type;
}

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.args});

  final ActivityScreenArgs args;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final _userRepository = AppServices.instance.userRepository;
  final _productRepository = AppServices.instance.productRepository;

  Future<List<Product>> _loadProducts() async {
    final user = await _userRepository.getCurrentUser();
    switch (widget.args.type) {
      case ActivityType.purchases:
        return _productRepository.getProductsByIds(user.purchases);
      case ActivityType.listings:
        return _productRepository.getProductsByIds(user.listings);
      case ActivityType.favorites:
        return _productRepository.getProductsByIds(user.favorites);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
      future: Future.wait<Object>([
        _loadProducts(),
        _userRepository.getCurrentUser(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final products = snapshot.data![0] as List<Product>;
        final user = snapshot.data![1] as AppUser;
        final favorites = user.favorites;
        return GradientScaffold(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.args.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('Aún no tienes elementos aquí.'))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          isFavorite: favorites.contains(product.id),
                          onFavoriteTap: () async {
                            await _userRepository.toggleFavorite(product.id);
                            if (mounted) setState(() {});
                          },
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.productDetail,
                            arguments: product.id,
                          ),
                        );
                      },
                    ),
            ),
              ],
            ),
          ),
        );
      },
    );
  }
}
