import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post.dart';
import 'package:untitled/model/content_post_model.dart';
import 'package:untitled/screen/homePage/widgets/create_post.dart';
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSearchBar(
                      homeViewModel.urlAvatar, homeViewModel.createPost),
                  if (homeViewModel.posts.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: homeViewModel.posts.length,
                      itemBuilder: (context, index) {
                        final post = homeViewModel.posts[index];
                        return CommonPost(post: post);
                      },
                    ),
                  if (homeViewModel.posts.isEmpty)
                    const Center(
                      child: Text('No posts available'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(
      String urlAvatar, Future<void> Function(ContentPostModel) onCreatePost) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(urlAvatar),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _showCreatePostDialog(onCreatePost: onCreatePost);
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                          FlutterI18n.translate(
                              context, "home.title_create_post"),
                          style: const TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showCreatePostDialog(
      {required Future<void> Function(ContentPostModel) onCreatePost}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1.1,
          child: CreatePostDialog(
            onCreatePost: onCreatePost,
          ),
        );
      },
    );
  }
}
