import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExploreSkeleton extends StatelessWidget {
  const ExploreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 220,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(width: 80, height: 12, color: Colors.white),
                  const Spacer(),
                  Container(width: 60, height: 12, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
