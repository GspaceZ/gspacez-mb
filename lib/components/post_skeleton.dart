import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonHeader(),
            _buildSkeletonTitle(),
            _buildSkeletonImage(context),
            _buildSkeletonIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildSkeletonHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildShimmerContainer(40, 40), // Circle avatar
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerContainer(15, 120), // Name
              const SizedBox(height: 4),
              _buildShimmerContainer(12, 80), // Username
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildShimmerContainer(20, double.infinity),
    );
  }

  Widget _buildSkeletonImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildShimmerContainer(MediaQuery.of(context).size.width / 1.5, double.infinity),
    );
  }

  Widget _buildSkeletonIcons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildShimmerContainer(20, 40),
          _buildShimmerContainer(20, 40),
          _buildShimmerContainer(20, 40),
        ],
      ),
    );
  }
}
