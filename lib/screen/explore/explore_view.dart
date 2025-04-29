import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/explore_post.dart';
import 'package:untitled/view_model/explore_view_model.dart';

import '../../components/explore_skeleton.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ExploreViewModel(),
      child: Consumer<ExploreViewModel>(
        builder: (context, exploreViewModel, child) {
          return RefreshIndicator(
            onRefresh: () => exploreViewModel.fetchArticles(isRefresh: true),
            child: ListView.builder(
              controller: exploreViewModel.scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: exploreViewModel.posts.length + (exploreViewModel.isLoading && exploreViewModel.posts.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < exploreViewModel.posts.length) {
                  final post = exploreViewModel.posts[index];
                  return ExplorePost(post: post);
                } else {
                  return const ExploreSkeleton();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
