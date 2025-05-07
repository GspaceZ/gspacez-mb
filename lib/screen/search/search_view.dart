import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post_simple.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/model/search_item.dart';
import 'package:untitled/router/app_router.dart';
import 'package:untitled/view_model/search_view_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SearchViewModel(),
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildSearchBar(viewModel),
                      const SizedBox(height: 10),
                      Expanded(
                        child: viewModel.isSearch
                            ? Column(
                                children: [
                                  TabBar(
                                    controller: _tabController,
                                    tabs: [
                                      Tab(
                                          child: _buildTitle(
                                              "User", Icons.person,
                                              color: Colors.indigo)),
                                      Tab(
                                          child: _buildTitle(
                                              " Squad", Icons.group,
                                              color: Colors.indigo)),
                                      Tab(
                                          child: _buildTitle(
                                              "Post", Icons.post_add_rounded,
                                              color: Colors.indigo)),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // Users Tab
                                        (viewModel.searchResults.isEmpty)
                                            ? const Center(
                                                child: Text('No user found'),
                                              )
                                            : ListView.builder(
                                                itemCount: viewModel
                                                    .searchResults.length,
                                                itemBuilder: (context, index) {
                                                  return _buildSearchItem(
                                                      viewModel,
                                                      viewModel.searchResults[
                                                          index]);
                                                },
                                              ),

                                        // Squads Tab
                                        (viewModel.searchSquad.isEmpty)
                                            ? const Center(
                                                child: Text('No squads found'),
                                              )
                                            : ListView.builder(
                                                itemCount: viewModel
                                                    .searchSquad.length,
                                                itemBuilder: (context, index) {
                                                  return _buildSquadItemView(
                                                      viewModel,
                                                      viewModel
                                                          .searchSquad[index]);
                                                },
                                              ),
                                        // Posts Tab
                                        (viewModel.searchPost.isEmpty)
                                            ? const Center(
                                                child: Text('No posts found'),
                                              )
                                            : ListView.builder(
                                                itemCount:
                                                    viewModel.searchPost.length,
                                                itemBuilder: (context, index) {
                                                  return CommonPostSimple(
                                                      post: viewModel
                                                              .listPostModel[
                                                          index]);
                                                },
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : _buildReCommentList(viewModel),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(SearchViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: viewModel.searchController,
        decoration: const InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        onSubmitted: (value) {
          viewModel.searchAll(value);
        },
      ),
    );
  }

  _buildReCommentList(
    SearchViewModel viewModel,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (viewModel.searchHistory.isNotEmpty &&
              viewModel.searchController.text.isEmpty)
            _buildListSearch(
              viewModel.searchHistory,
              viewModel,
              'History',
              Icons.history,
            ),
          if (viewModel.recommendedUserSearch.isNotEmpty)
            _buildListSearch(
              viewModel.recommendedUserSearch,
              viewModel,
              'Users',
              Icons.person,
            ),
          if (viewModel.recommendedSquadSearch.isNotEmpty)
            _buildListSearch(
              viewModel.recommendedSquadSearch,
              viewModel,
              'Squads',
              Icons.group,
            ),
          if (viewModel.recommendedPostSearch.isNotEmpty)
            _buildListSearch(
              viewModel.recommendedPostSearch,
              viewModel,
              'Posts',
              Icons.post_add,
            ),
        ],
      ),
    );
  }

  _buildSearchItem(
    SearchViewModel viewModel,
    SearchItem item,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage(item.imageUrl ?? AppConstants.urlImageDefault),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            maxLines: 2,
          ),
          Text(
            item.title ?? "",
            maxLines: 3,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      trailing: _buildChip(item.type.name),
      onTap: () async {
        viewModel.addToSearchHistory(item);
        if (item.type == SearchType.profile) {
          Navigator.pushNamed(
            context,
            AppRoutes.profile,
            arguments: item.id,
          );
        } else if (item.type == SearchType.squad) {
          Navigator.pushNamed(
            context,
            AppRoutes.squadDetail,
            arguments: item.id,
          );
        } else if (item.type == SearchType.post) {
          final post = await viewModel.getPostById(item.id);
          if (mounted) {
            Navigator.pushNamed(context, AppRoutes.postDetail, arguments: post);
          }
        }
      },
    );
  }

  _buildChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.indigo),
          color: Colors.white),
      child: Text(
        name.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  _buildTitle(String title, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color ?? Colors.grey,
          ),
          Text(
            title,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _buildListSearch(List<SearchItem> list, SearchViewModel viewModel,
      String title, IconData icon) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length + 2,
      itemBuilder: (context, index) {
        return (index == 0)
            ? _buildTitle(title, icon)
            : (index == list.length + 1)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _buildSearchItem(viewModel, list[index - 1]),
                  );
      },
    );
  }

  _buildSquadItemView(
    SearchViewModel viewModel,
    SearchItem item,
  ) {
    final squad = viewModel.listSquadModel.firstWhere(
      (element) => element.tagName == item.id,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              squad.avatarUrl ?? AppConstants.urlImageDefault,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                squad.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "@${squad.tagName}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.indigo),
                        color: Colors.grey.shade200),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.group,
                          color: Colors.indigo,
                          size: 12,
                        ),
                        Text(
                          squad.totalMembers.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.indigo),
                        color: Colors.grey.shade200),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.post_add,
                          color: Colors.indigo,
                          size: 12,
                        ),
                        Text(
                          squad.totalPosts.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: (squad.privacy.toUpperCase() == "PRIVATE")
                        ? Colors.red
                        : Colors.indigo),
                color: Colors.white),
            child: Row(
              children: [
                Icon(
                  (squad.privacy.toUpperCase() == "PRIVATE")
                      ? Icons.lock
                      : Icons.public,
                  color: (squad.privacy.toUpperCase() == "PRIVATE")
                      ? Colors.red
                      : Colors.indigo,
                  size: 12,
                ),
                Text(
                  squad.privacy.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: (squad.privacy.toUpperCase() == "PRIVATE")
                        ? Colors.red
                        : Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
