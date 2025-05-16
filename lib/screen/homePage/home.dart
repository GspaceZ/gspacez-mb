import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post_simple.dart';
import 'package:untitled/components/post_skeleton.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/view_model/home_view_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// lib/screen/homePage/home.dart
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          return RefreshIndicator(
            onRefresh: () => homeViewModel.fetchPost(isRefresh: true),
            child: CustomScrollView(
              controller: homeViewModel.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildWidgetSearch(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = homeViewModel.posts[index];
                      return CommonPostSimple(post: post);
                    },
                    childCount: homeViewModel.posts.length,
                  ),
                ),
                if (homeViewModel.isLoading)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: PostSkeleton(),
                      ),
                      childCount: 3,
                    ),
                  ),
                if (!homeViewModel.hasMore && homeViewModel.posts.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'No more posts',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildWidgetSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.search);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Search in Gspacez',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
