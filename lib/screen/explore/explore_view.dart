import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/explore_post.dart';
import 'package:untitled/view_model/explore_view_model.dart';

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
              itemCount: exploreViewModel.posts.length,
              itemBuilder: (context, index) {
                final post = exploreViewModel.posts[index];
                return ExplorePost(post: post);
              },
            ),
          );
        },
      ),
    );
  }
}
