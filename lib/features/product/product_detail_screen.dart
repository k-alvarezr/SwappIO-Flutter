import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/app_user.dart';
import '../../data/models/product.dart';
import '../../routes/app_routes.dart';
import '../shared/widgets/glass_panel.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _productRepository = AppServices.instance.productRepository;
  final _userRepository = AppServices.instance.userRepository;
  final _chatRepository = AppServices.instance.chatRepository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final product = snapshot.data![0] as Product;
        final owner = snapshot.data![1] as AppUser;
        final currentUser = snapshot.data![2] as AppUser;
        final suggestions = snapshot.data![3] as List<Product>;
        final isOwner = currentUser.id == owner.id;
        return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    SizedBox(height: 360, child: _ProductHero(colors: product.images)),
                    Positioned(
                      top: 48,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.7),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -32),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    child: Column(
                      children: [
                        GlassPanel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Size ${product.size}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                                            const SizedBox(width: 4),
                                            Expanded(child: Text(product.location, style: const TextStyle(color: AppColors.textMuted))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${product.price.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary),
                                  ),
                                ],
                              ),
                              const Divider(height: 28),
                              const Text('Description', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(product.description, style: const TextStyle(color: AppColors.textMuted)),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _Badge(
                                    label: product.condition,
                                    background: _conditionBackground(product.condition),
                                    foreground: _conditionColor(product.condition),
                                  ),
                                  ...product.styleTags.map((tag) => _Badge(label: tag)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (product.latitude != null && product.longitude != null)
                          GlassPanel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Meetup Location', style: TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 10),
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(colors: [Color(0xFFB2DFDB), Color(0xFFE0F2F1)]),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.place_rounded, size: 36, color: AppColors.primary),
                                        SizedBox(height: 8),
                                        Text('Mapa mock del punto de encuentro'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => Navigator.of(context).pushNamed(AppRoutes.sellerProfile, arguments: owner.id),
                          child: GlassPanel(
                            child: Row(
                              children: [
                                CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Text(owner.name.substring(0, 1))),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(owner.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 4),
                                      const Row(
                                        children: [
                                          Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
                                          SizedBox(width: 4),
                                          Text('Vendedor', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isOwner)
                                  IconButton(
                                    onPressed: () async {
                                      final chatId = await _chatRepository.startChatForProduct(product.id);
                                      Navigator.of(context).pushNamed(AppRoutes.chatDetail, arguments: chatId);
                                    },
                                    icon: const Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (suggestions.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('You Might Also Like', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 260,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: suggestions.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final suggested = suggestions[index];
                                return SizedBox(
                                  width: 180,
                                  child: Card(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(22),
                                      onTap: () => Navigator.of(context).pushReplacementNamed(
                                        AppRoutes.productDetail,
                                        arguments: suggested.id,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: _ProductHero(colors: suggested.images)),
                                            const SizedBox(height: 10),
                                            Text(suggested.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                            const SizedBox(height: 4),
                                            Text('\$${suggested.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GlassPanel(
              padding: const EdgeInsets.all(16),
              radius: 24,
              child: Row(
                children: isOwner
                    ? [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Listing'),
                                  content: const Text('Are you sure you want to permanently delete this product?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                await _productRepository.deleteProduct(product.id);
                                if (!mounted) return;
                                Navigator.of(context).pop();
                              }
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.12),
                              foregroundColor: Colors.red,
                            ),
                            label: const Text('Delete Listing'),
                          ),
                        ),
                      ]
                    : [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Price', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w700)),
                              Text('\$${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.shopping_bag_outlined),
                            label: const Text('Buy Now'),
                          ),
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
        );
      },
    );
  }

  Future<List<Object>> _loadData() async {
    final product = await _productRepository.getProductById(widget.productId);
    final owner = await _userRepository.getUserById(product.ownerId);
    final currentUser = await _userRepository.getCurrentUser();
    final suggestions = await _productRepository.getSuggestions(product.id);
    return [product, owner, currentUser, suggestions];
  }

  Color _conditionBackground(String condition) {
    switch (condition) {
      case 'New with tags':
        return const Color(0xFFE8F5E9);
      case 'Like New':
        return const Color(0xFFE3F2FD);
      case 'Good':
        return const Color(0xFFFFF3E0);
      case 'Fair':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _conditionColor(String condition) {
    switch (condition) {
      case 'New with tags':
        return const Color(0xFF2E7D32);
      case 'Like New':
        return const Color(0xFF1565C0);
      case 'Good':
        return const Color(0xFFEF6C00);
      case 'Fair':
        return const Color(0xFFC62828);
      default:
        return Colors.black54;
    }
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    this.background = Colors.white,
    this.foreground = AppColors.textPrimary,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: foreground),
      ),
    );
  }
}

class _ProductHero extends StatelessWidget {
  const _ProductHero({required this.colors});

  final List<String> colors;

  @override
  Widget build(BuildContext context) {
    final parsed = colors
        .map((value) => Color(int.parse('FF${value.replaceAll('#', '')}', radix: 16)))
        .toList();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: parsed.length >= 2 ? parsed : [Colors.blueGrey, Colors.white],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 40,
            right: 40,
            top: 24,
            bottom: 24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(42),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
