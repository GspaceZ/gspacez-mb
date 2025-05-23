import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post_simple.dart';
import 'package:untitled/view_model/tag_view_model.dart';

class TagView extends StatelessWidget {
  const TagView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TagViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tags",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.tag,
                color: Colors.black,
                size: 24,
              ),
            ],
          ),
        ),
        body: Consumer<TagViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: viewModel.searchController,
                    onChanged: viewModel.searchTags,
                    decoration: InputDecoration(
                      hintText: 'Search tags...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                if (viewModel.searchResults.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.searchResults.length,
                      itemBuilder: (context, index) {
                        final tag = viewModel.searchResults[index];
                        return ListTile(
                          title: Text(tag),
                          onTap: () {
                            viewModel.selectTag(tag);
                          },
                        );
                      },
                    ),
                  )
                else if (viewModel.currentTag.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Text(
                            'All posts with tag #${viewModel.currentTag}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: viewModel.refreshPosts,
                            child: ListView.builder(
                              controller: viewModel.scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: viewModel.posts.length,
                              itemBuilder: (context, index) {
                                final post = viewModel.posts[index];
                                return CommonPostSimple(post: post);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Text(
                            'Populars Tags',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 4,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 16,
                              children: viewModel.popularsTags.map((tag) {
                                return GestureDetector(
                                  onTap: () => viewModel.selectTag(tag),
                                  child: Text(
                                    "#$tag",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (viewModel.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
