import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post.dart';
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
              itemCount: homeViewModel.posts.length,
              itemBuilder: (context, index) {
                final post = homeViewModel.posts[index];
                return CommonPost(
                  post: post,
                  onGetComment: () async {
                    return await homeViewModel.getComment(post);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
