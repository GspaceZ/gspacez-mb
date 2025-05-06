import 'package:flutter/material.dart';
import 'package:untitled/data/local/search_item_service.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/model/search_item.dart';
import 'package:untitled/service/post_service.dart';
import 'package:untitled/service/squad_service.dart';
import 'package:untitled/service/user_service.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isSearch = false;
  List<SearchItem> searchResults = []; // search results used for profiles
  List<SearchItem> searchHistory = [];
  List<SearchItem> recommendedSearch = [];
  List<SearchItem> searchSquad = []; // search results used for squads
  List<SearchItem> searchPost = []; // search results used for groups
  List<PostModelResponse> listPostModel = [];
  List<SearchItem> postChangeSearch = [];
  List<SearchItem> squadChangeSearch = [];
  List<SearchItem> userChangeSearch = [];

  SearchViewModel() {
    _init();
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        onSearchChanged(searchController.text);
      } else {
        clearSearch();
      }
    });
  }

  _init() {
    // Initialize any necessary data or state
    searchHistory = SearchItemService.getAllSearchItems();
    notifyListeners();
  }

  Future<void> searchAll(String query) async {
    if (searchController.text.isNotEmpty) {
      isSearch = true;
      isLoading = true;
      notifyListeners();
      await Future.wait([
        searchProfile(query),
        searchSquadFromApi(query),
        searchPostFromApi(query),
      ]);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProfile(String query) async {
    if (searchController.text.isNotEmpty) {
      final listUser = await UserService.instance.searchUser(query, 20);
      if (listUser.isNotEmpty) {
        for (var element in listUser) {
          final searchItem = SearchItem(
            name: '${element.firstName} ${element.lastName}',
            id: element.profileTag,
            imageUrl: element.avatarUrl,
            type: SearchType.profile,
          );
          searchResults.add(searchItem);
          notifyListeners();
        }
      }
    }
  }

  Future<void> searchPostFromApi(String query) async {
    if (searchController.text.isNotEmpty) {
      listPostModel = await PostService.instance.searchPost(query, 20);
      if (listPostModel.isNotEmpty) {
        for (var element in listPostModel) {
          final searchItem = SearchItem(
            name: element.profileName,
            id: element.id,
            imageUrl: element.previewImage,
            title: element.title,
            type: SearchType.post,
          );
          searchPost.add(searchItem);
          notifyListeners();
        }
      }
    }
  }

  Future<void> searchSquadFromApi(String query) async {
    if (searchController.text.isNotEmpty) {
      notifyListeners();
      final listSquad = await SquadService.instance.searchSquad(query, 20);
      if (listSquad.isNotEmpty) {
        for (var element in listSquad) {
          final searchItem = SearchItem(
            name: element.name,
            id: element.tagName,
            imageUrl: element.avatarUrl,
            type: SearchType.squad,
          );
          searchSquad.add(searchItem);
        }
      }
    }
  }

  void onSearchChanged(String query) {
    if (query.isNotEmpty) {
      // filter search results based on the query
      // searchHistory = searchHistory
      //     .where((result) =>
      //         result.name.toLowerCase().contains(query.toLowerCase()))
      //     .toList();
      onRecommendedSearchChanged(query);
    } else {
      clearSearch();
    }
    notifyListeners();
  }

  Future<void> onRecommendedSearchChanged(String query) async {
    recommendedSearch.clear();
    await Future.wait([
      _fetchPostChangeSearch(query),
      _fetchSquadChangeSearch(query),
      _fetchUserChangeSearch(query),
    ]);
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    recommendedSearch.clear();
    isSearch = false;
    searchResults.clear();
    notifyListeners();
  }

  void removeFromSearchHistory(SearchItem item) {
    searchHistory.removeWhere((result) => item.id == result.id);
    SearchItemService.deleteSearchItem(item.id);
    notifyListeners();
  }

  void removeSearchResults(SearchItem item) {
    searchResults.removeWhere((result) => result.id == item.id);
    notifyListeners();
  }

  void addToSearchHistory(SearchItem item) {
    searchHistory.add(item);
    SearchItemService.saveSearchItem(item.id, item);
    notifyListeners();
  }

  Future<void> _fetchPostChangeSearch(String query) async {
    final listPost = await PostService.instance.searchPost(query, 2);
    if (listPost.isNotEmpty) {
      for (var element in listPost) {
        final searchItem = SearchItem(
          name: element.profileName,
          id: element.id,
          title: element.title,
          imageUrl: element.avatarUrl,
          type: SearchType.post,
        );
        recommendedSearch.add(searchItem);
      }
    }
  }

  Future<void> _fetchSquadChangeSearch(String query) async {
    final listSquad = await SquadService.instance.searchSquad(query, 2);
    if (listSquad.isNotEmpty) {
      for (var element in listSquad) {
        final searchItem = SearchItem(
          name: element.name,
          id: element.tagName,
          imageUrl: element.avatarUrl,
          type: SearchType.squad,
        );
        recommendedSearch.add(searchItem);
      }
    }
  }

  Future<void> _fetchUserChangeSearch(String query) async {
    final listUser = await UserService.instance.searchUser(query, 2);
    if (listUser.isNotEmpty) {
      for (var element in listUser) {
        final searchItem = SearchItem(
          name: '${element.firstName} ${element.lastName}',
          id: element.profileTag,
          imageUrl: element.avatarUrl,
          type: SearchType.profile,
        );
        recommendedSearch.add(searchItem);
      }
    }
  }
}
