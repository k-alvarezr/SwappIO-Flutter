import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/charity.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/swapio_bottom_nav.dart';
import '../shared/widgets/gradient_scaffold.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final _charityRepository = AppServices.instance.charityRepository;
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<Charity> _charities = const [];
  bool _isLoading = true;

  List<String> get _categories => ['All', 'Women', 'Children', 'Winter Gear', 'Professional'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final charities = await _charityRepository.getCharities();
    if (!mounted) return;
    setState(() {
      _charities = charities;
      _isLoading = false;
    });
  }

  List<Charity> get _filtered {
    final query = _searchController.text.toLowerCase();
    return _charities.where((charity) {
      final matchesSearch = query.isEmpty ||
          charity.name.toLowerCase().contains(query) ||
          charity.location.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' ||
          charity.tags.any((tag) => tag.toLowerCase() == _selectedCategory.toLowerCase());
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final charities = _filtered;
    final featured = charities.isNotEmpty ? charities.first : null;

    return GradientScaffold(
      bottomNavigationBar: const SwapioBottomNav(currentRoute: AppRoutes.donate),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
        children: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_rounded)),
              const Expanded(
                child: Text(
                  'Donate to Charities',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search charities in Bogotá...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = category),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          const Text('FEATURED CAUSE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          if (featured != null)
            _FeaturedCharityCard(
              charity: featured,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.charityDetail, arguments: featured.id),
            ),
          const SizedBox(height: 18),
          const Text('ALL CHARITIES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          ...charities.map(
            (charity) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CharityCard(
                charity: charity,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.charityDetail, arguments: charity.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCharityCard extends StatelessWidget {
  const _FeaturedCharityCard({required this.charity, required this.onTap});

  final Charity charity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 215,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF7A8332), Color(0xFF5D6F2C), Color(0xFF95C2D6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF0E98B0), borderRadius: BorderRadius.circular(8)),
                  child: const Text('FEATURED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.location_on_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 2),
                Text(charity.location, style: const TextStyle(color: Colors.white)),
              ],
            ),
            const Spacer(),
            Text(charity.name, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(charity.description, maxLines: 2, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            Row(
              children: [
                ...charity.tags.take(2).map(
                  (tag) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(8)),
                      child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                  child: const Text('Donate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CharityCard extends StatelessWidget {
  const _CharityCard({required this.charity, required this.onTap});

  final Charity charity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.58), borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.16), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.volunteer_activism_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(charity.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(charity.location, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 10),
            Text(charity.description, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 12),
            Row(
              children: [
                ...charity.tags.take(2).map(
                  (tag) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(tag, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                    ),
                  ),
                ),
                const Spacer(),
                Text(charity.distance, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
