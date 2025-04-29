import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post_simple.dart';
import 'package:untitled/components/post_skeleton.dart';
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
              itemCount: homeViewModel.posts.length + (homeViewModel.isLoading && homeViewModel.posts.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < homeViewModel.posts.length) {
                  final post = homeViewModel.posts[index];
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
}
