import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post.dart';
import 'package:untitled/view_model/history_view_model.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HistoryViewModel(),
      child: Consumer<HistoryViewModel>(
        builder: (context, historyViewModel, child) {
          return RefreshIndicator(
            onRefresh: () => historyViewModel.fetchHistoryPosts(isRefresh: true),
            child: ListView.builder(
              controller: historyViewModel.scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: historyViewModel.posts.length,
              itemBuilder: (context, index) {
                final post = historyViewModel.posts[index];
                return CommonPost(
                  post: post,
                  onGetComment: () async {
                    return await historyViewModel.getComment(post);
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
