import 'package:flutter/material.dart';

import 'AppColorsView.dart';
import '../../model/ProductModel.dart';

class ProductCardView extends StatelessWidget {
  const ProductCardView({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
  });

  final ProductModel product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                        child: _ProductArtwork(colors: product.images),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: Colors.white.withOpacity(0.88),
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed: onFavoriteTap,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.pink : AppColorsView.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColorsView.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColorsView.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColorsView.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductArtwork extends StatelessWidget {
  const _ProductArtwork({required this.colors});

  final List<String> colors;

  @override
  Widget build(BuildContext context) {
    final networkImage = _networkImage();
    if (networkImage != null) {
      return Image.network(
        networkImage,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildGradientArtwork(),
      );
    }
    return _buildGradientArtwork();
  }

  Widget _buildGradientArtwork() {
    final parsed = colors.map(_hexToColor).whereType<Color>().toList();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: parsed.length >= 2
              ? parsed
              : [const Color(0xFF90CAF9), const Color(0xFFE3F2FD)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 18,
            right: 18,
            top: 22,
            bottom: 24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          Positioned(
            left: 38,
            right: 38,
            top: 18,
            height: 28,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _networkImage() {
    for (final value in colors) {
      if (value.startsWith('http')) return value;
    }
    return null;
  }

  Color? _hexToColor(String value) {
    final normalized = value.replaceAll('#', '');
    if (normalized.length != 6) return null;
    return Color(int.parse('FF$normalized', radix: 16));
  }
}




