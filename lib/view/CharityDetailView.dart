import 'package:flutter/material.dart';

import '../model/CharityModel.dart';
import '../model/ProductModel.dart';
import '../viewModel/AppServicesViewModel.dart';
import 'shared/AppColorsView.dart';
import 'shared/AppRoutesView.dart';
import 'shared/AsyncStateView.dart';

class CharityDetailView extends StatefulWidget {
  const CharityDetailView({super.key, required this.charityId});

  final String charityId;

  @override
  State<CharityDetailView> createState() => _CharityDetailViewState();
}

class _CharityDetailViewState extends State<CharityDetailView> {
  final _charityRepository = AppServicesViewModel.instance.charityRepository;
  final _productRepository = AppServicesViewModel.instance.productRepository;
  final _userRepository = AppServicesViewModel.instance.userRepository;

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : null,
      ),
    );
  }

  Future<void> _donateToCharity(CharityModel charity) async {
    try {
      final user = await _userRepository.getCurrentUser();
      final products = await _productRepository.getProductsByIds(user.listings);
      if (!mounted) return;

      final availableProducts = products
          .where((product) => product.status == ProductStatus.available)
          .toList();
      if (availableProducts.isEmpty) {
        _showMessage('No tienes publicaciones activas para donar.', isError: true);
        return;
      }

      final selectedProduct = await showModalBottomSheet<ProductModel>(
        context: context,
        builder: (sheetContext) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                title: Text(
                  'Selecciona una prenda',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              ...availableProducts.map(
                (product) => ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.location),
                  trailing: Text('\$${product.price.toStringAsFixed(0)}'),
                  onTap: () => Navigator.of(sheetContext).pop(product),
                ),
              ),
            ],
          ),
        ),
      );
      if (selectedProduct == null) return;

      await _productRepository.donateProduct(
        productId: selectedProduct.id,
        charityId: charity.id,
      );
      if (!mounted) return;
      _showMessage('Donacion registrada correctamente.');
    } catch (error) {
      if (!mounted) return;
      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CharityModel>(
      future: _charityRepository.getCharityById(widget.charityId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AsyncStateView(
            message: snapshot.error.toString().replaceFirst('Exception: ', ''),
            onRetry: () => setState(() {}),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final charity = snapshot.data!;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFF1F7F7), Color(0xFFE8F1F1), Color(0xFFE3EFF0)]),
            ),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
                      const Expanded(
                        child: Text('Charity Details', textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                      ),
                      IconButton(
                        onPressed: () => _showMessage('No hay ajustes adicionales para esta fundacion.'),
                        icon: const Icon(Icons.settings_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _HeroSection(
                    charity: charity,
                    onDonatePressed: () => _donateToCharity(charity),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Expanded(child: _StatsCard(icon: Icons.person_rounded, number: '12k+', label: 'Families')),
                      SizedBox(width: 10),
                      Expanded(child: _StatsCard(icon: Icons.favorite_rounded, number: '50k', label: 'Kg Clothes')),
                      SizedBox(width: 10),
                      Expanded(child: _StatsCard(icon: Icons.home_rounded, number: '450', label: 'Volunteers')),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _InfoCard(
                    title: 'Our Impact',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(charity.description, style: const TextStyle(color: AppColorsView.textMuted, height: 1.4)),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Text('Read full report', style: TextStyle(color: AppColorsView.primary, fontWeight: FontWeight.w700)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 16, color: AppColorsView.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _InfoCard(
                    title: 'Drop-off Points',
                    trailing: TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutesView.dropOffMap),
                      child: const Text('View Map'),
                    ),
                    child: const Column(
                      children: [
                        _DropoffPreview(title: 'Sede Principal - Minuto', address: 'Calle 81A #73A-22', status: 'Open', distance: '0.8 km away'),
                        SizedBox(height: 10),
                        _DropoffPreview(title: 'Centro de Acopio Usaquen', address: 'Carrera 7 #119-14', status: 'Closes 5pm', distance: '4.2 km away'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _InfoCard(
                    title: 'Contact Info',
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ActionCircle(icon: Icons.phone_rounded, label: 'Call'),
                            _ActionCircle(icon: Icons.chat_rounded, label: 'WhatsApp'),
                            _ActionCircle(icon: Icons.mail_rounded, label: 'Email'),
                            _ActionCircle(icon: Icons.language_rounded, label: 'Website'),
                          ],
                        ),
                        const Divider(height: 28),
                        _ContactRow(icon: Icons.phone_rounded, text: charity.number),
                        const SizedBox(height: 10),
                        _ContactRow(icon: Icons.mail_rounded, text: charity.email),
                        const SizedBox(height: 10),
                        _ContactRow(icon: Icons.language_rounded, text: charity.website),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.charity,
    required this.onDonatePressed,
  });

  final CharityModel charity;
  final VoidCallback onDonatePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 61,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 56,
            backgroundColor: AppColorsView.primary,
            child: Text(charity.name.substring(0, 2).toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 14),
        Text(charity.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(color: AppColorsView.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(999)),
          child: const Text('Verified Nonprofit', style: TextStyle(color: AppColorsView.primary, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
        Text(charity.impact, textAlign: TextAlign.center, style: const TextStyle(color: AppColorsView.textMuted, height: 1.4)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onDonatePressed,
          icon: const Icon(Icons.favorite_rounded),
          label: const Text('Donate Clothes Now'),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.62), borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.icon, required this.number, required this.label});

  final IconData icon;
  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.62), borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: AppColorsView.primary.withOpacity(0.12), child: Icon(icon, color: AppColorsView.primary)),
          const SizedBox(height: 8),
          Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColorsView.textMuted)),
        ],
      ),
    );
  }
}

class _DropoffPreview extends StatelessWidget {
  const _DropoffPreview({required this.title, required this.address, required this.status, required this.distance});

  final String title;
  final String address;
  final String status;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: const LinearGradient(colors: [Color(0xFF9ED1DB), Color(0xFF4C8CA0)])),
            child: const Icon(Icons.place_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(address, style: const TextStyle(fontSize: 12, color: AppColorsView.textMuted)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 'Open' ? const Color(0xFFE4F5EA) : const Color(0xFFF1F2F4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: status == 'Open' ? const Color(0xFF2E9B57) : const Color(0xFF6F7880)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(distance, style: const TextStyle(fontSize: 11, color: AppColorsView.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded, color: AppColorsView.primary),
        ],
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: AppColorsView.primary.withOpacity(0.12), child: Icon(icon, color: AppColorsView.primary)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColorsView.textMuted)),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: AppColorsView.primary.withOpacity(0.12), child: Icon(icon, size: 18, color: AppColorsView.primary)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: AppColorsView.textMuted))),
      ],
    );
  }
}
