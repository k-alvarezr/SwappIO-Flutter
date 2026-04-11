import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/app_services.dart';
import '../../data/models/dropoff_point.dart';

class DropOffMapScreen extends StatelessWidget {
  const DropOffMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dropOffRepository = AppServices.instance.dropOffRepository;

    return FutureBuilder<List<DropOffPoint>>(
      future: dropOffRepository.getDropOffPoints(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final points = snapshot.data!;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)]),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
                        const Expanded(
                          child: Text('Drop-off Map', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.55), borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [Color(0xFFB2DFDB), Color(0xFFE0F2F1)])),
                              child: const Stack(
                                children: [
                                  Positioned(top: 70, left: 90, child: Icon(Icons.place_rounded, color: AppColors.primary, size: 36)),
                                  Positioned(top: 120, right: 100, child: Icon(Icons.place_rounded, color: AppColors.primary, size: 36)),
                                  Positioned(bottom: 80, left: 140, child: Icon(Icons.place_rounded, color: AppColors.primary, size: 36)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              itemCount: points.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final point = points[index];
                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.75), borderRadius: BorderRadius.circular(18)),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(backgroundColor: Color(0x1A077288), child: Icon(Icons.place_rounded, color: AppColors.primary)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(point.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 4),
                                            Text(point.address, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                            const SizedBox(height: 4),
                                            Text('${point.opensAt} - ${point.closesAt}', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
