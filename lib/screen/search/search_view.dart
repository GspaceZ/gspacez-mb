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
                                    tabs: const [
                                      Tab(text: 'Users'),
                                      Tab(text: 'Squads'),
                                      Tab(text: 'Posts'),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // Users Tab
                                        ListView.builder(
                                          itemCount:
                                              viewModel.searchResults.length,
                                          itemBuilder: (context, index) {
                                            return _buildSearchItem(viewModel,
                                                viewModel.searchResults[index]);
                                          },
                                        ),

                                        // Squads Tab
                                        ListView.builder(
                                          itemCount:
                                              viewModel.searchSquad.length,
                                          itemBuilder: (context, index) {
                                            return _buildSearchItem(viewModel,
                                                viewModel.searchSquad[index]);
                                          },
                                        ),
                                        // Posts Tab
                                        ListView.builder(
                                          itemCount:
                                              viewModel.searchPost.length,
                                          itemBuilder: (context, index) {
                                            return CommonPostSimple(
                                                post: viewModel
                                                    .listPostModel[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : _buildHistoryList(viewModel),
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
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          viewModel.searchAll(value);
        },
      ),
    );
  }

  _buildHistoryList(
    SearchViewModel viewModel,
  ) {
    return ListView.builder(
      itemCount: viewModel.recommendedSearch.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child:
              _buildSearchItem(viewModel, viewModel.recommendedSearch[index]),
        );
      },
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
      title: Text(item.title ?? item.name),
      trailing: _buildChip(item.type.name),
      onTap: () {
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
          final post = viewModel.listPostModel
              .firstWhere((element) => element.id == item.id);
          Navigator.pushNamed(
            context,
            AppRoutes.postDetail,
            arguments: post,
          );
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
}
