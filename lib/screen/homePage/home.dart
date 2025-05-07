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

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          return RefreshIndicator(
            onRefresh: homeViewModel.fetchPost,
            child: ListView.builder(
              controller: homeViewModel.scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: homeViewModel.posts.length +
                  1 + // thêm 1 cho search bar
                  (homeViewModel.isLoading && homeViewModel.posts.isNotEmpty
                      ? 1
                      : 0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildWidgetSearch();
                }

                final postIndex = index - 1;

                if (postIndex < homeViewModel.posts.length) {
                  final post = homeViewModel.posts[postIndex];
                  return CommonPostSimple(post: post);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PostSkeleton(),
                  );
                }
              },
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
