import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/product.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/swapio_bottom_nav.dart';
import '../shared/widgets/gradient_scaffold.dart';
import '../shared/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productRepository = AppServices.instance.productRepository;
  final _userRepository = AppServices.instance.userRepository;
  final _searchController = TextEditingController();
  String _selectedTag = 'All';
  List<String> _tags = const [];
  List<Product> _products = const [];
  Set<String> _favoriteIds = <String>{};
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final user = await _userRepository.getCurrentUser();
    final tags = await _productRepository.getTags();
    final products = await _productRepository.getTrendingProducts();
    if (!mounted) return;
    setState(() {
      _userName = user.name;
      _tags = tags;
      _products = products;
      _favoriteIds = user.favorites.toSet();
      _selectedTag = tags.contains(_selectedTag) ? _selectedTag : (tags.isNotEmpty ? tags.first : 'All');
      _isLoading = false;
    });
  }

  List<Product> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _products.where((product) {
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          (product.brand?.toLowerCase().contains(query) ?? false) ||
          product.description.toLowerCase().contains(query);
      final matchesTag = _selectedTag == 'All' ||
          _selectedTag == 'Trending' ||
          product.styleTags.any((tag) => tag.toLowerCase() == _selectedTag.toLowerCase());
      return matchesSearch && matchesTag;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final products = _filteredProducts;

    return GradientScaffold(
      bottomNavigationBar: const SwapioBottomNav(currentRoute: AppRoutes.home),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'SwappIO - Home',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Hi, $_userName',
                              style: const TextStyle(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search for clothes, brands...',
                      prefixIcon: Icon(Icons.search_rounded),
                      suffixIcon: Icon(Icons.tune_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tags.map((tag) {
                        final selected = tag == _selectedTag;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(tag),
                            selected: selected,
                            onSelected: (_) => setState(() => _selectedTag = tag),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            backgroundColor: Colors.white.withOpacity(0.35),
                            side: BorderSide.none,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Products Now',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  final isFavorite = _favoriteIds.contains(product.id);
                  return ProductCard(
                    product: product,
                    isFavorite: isFavorite,
                    onFavoriteTap: () async {
                      await _userRepository.toggleFavorite(product.id);
                      final user = await _userRepository.getCurrentUser();
                      if (!mounted) return;
                      setState(() => _favoriteIds = user.favorites.toSet());
                    },
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.productDetail,
                      arguments: product.id,
                    ),
                  );
                },
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
