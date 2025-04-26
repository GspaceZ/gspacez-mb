import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post_simple.dart';
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
            child: (homeViewModel.posts.isNotEmpty)
                ? ListView.builder(
                    controller: homeViewModel.scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: homeViewModel.posts.length,
                    itemBuilder: (context, index) {
                      final post = homeViewModel.posts[index];
                      return CommonPostSimple(
                        post: post,
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      ),
    );
  }
}
