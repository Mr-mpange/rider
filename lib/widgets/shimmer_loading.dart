import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/theme/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceContainer,
            highlightColor: AppColors.surfaceContainerHigh,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ShimmerPlaceholders extends StatelessWidget {
  const ShimmerPlaceholders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (_) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.surfaceContainer,
                highlightColor: AppColors.surfaceContainerHigh,
                child: const CircleAvatar(radius: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.surfaceContainer,
                      highlightColor: AppColors.surfaceContainerHigh,
                      child: Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: AppColors.surfaceContainer,
                      highlightColor: AppColors.surfaceContainerHigh,
                      child: Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
