import 'package:flutter/material.dart';
import 'package:untitled/data/local/search_item_service.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/model/search_item.dart';
import 'package:untitled/model/squad_response.dart';
import 'package:untitled/service/post_service.dart';
import 'package:untitled/service/squad_service.dart';
import 'package:untitled/service/user_service.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isSearch = false;
  List<SearchItem> searchResults = []; // search results used for profiles
  List<SearchItem> searchHistory = [];
  List<SearchItem> searchSquad = []; // search results used for squads
  List<SearchItem> searchPost = []; // search results used for groups
  List<SearchItem> recommendedUserSearch = [];
  List<SearchItem> recommendedSquadSearch = [];
  List<SearchItem> recommendedPostSearch = [];
  List<PostModelResponse> listPostModel = [];
  List<SquadResponse> listSquadModel = [];
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

  _init() async {
    // Initialize any necessary data or state
    searchHistory = SearchItemService.getAllSearchItems();
    notifyListeners();
  }

  Future<void> searchAll(String query) async {
    if (searchController.text.isNotEmpty) {
      searchResults.clear();
      searchSquad.clear();
      searchPost.clear();
      recommendedUserSearch.clear();
      recommendedSquadSearch.clear();
      recommendedPostSearch.clear();
      listSquadModel.clear();
      listPostModel.clear();
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
              id: element.id,
              imageUrl: element.avatarUrl,
              type: SearchType.profile,
              title: element.id);
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
            name: element.title ?? "",
            id: element.id,
            imageUrl: element.previewImage,
            title: element.content.text,
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
      listSquadModel = await SquadService.instance.searchSquad(query, 20);
      if (listSquadModel.isNotEmpty) {
        for (var element in listSquadModel) {
          final searchItem = SearchItem(
              name: element.name,
              id: element.tagName,
              imageUrl: element.avatarUrl,
              type: SearchType.squad,
              title: element.tagName);
          searchSquad.add(searchItem);
        }
      }
    }
  }

  Future<void> onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      if (!isSearch) {
        onRecommendedSearchChanged(query);
      } else {
        searchResults.clear();
        searchSquad.clear();
        searchPost.clear();
        recommendedUserSearch.clear();
        recommendedSquadSearch.clear();
        recommendedPostSearch.clear();
        listSquadModel.clear();
        listPostModel.clear();
        notifyListeners();
        await Future.wait([
          searchProfile(query),
          searchSquadFromApi(query),
          searchPostFromApi(query),
        ]);
        notifyListeners();
      }
    } else {
      clearSearch();
    }
    notifyListeners();
  }

  Future<void> onRecommendedSearchChanged(String query) async {
    recommendedUserSearch.clear();
    recommendedSquadSearch.clear();
    recommendedPostSearch.clear();
    await Future.wait([
      _fetchPostChangeSearch(query),
      _fetchSquadChangeSearch(query),
      _fetchUserChangeSearch(query),
    ]);
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    recommendedUserSearch.clear();
    recommendedSquadSearch.clear();
    recommendedPostSearch.clear();
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
    final exists = searchHistory.any((e) => e.id == item.id);
    if (!exists) {
      searchHistory.add(item);
      SearchItemService.saveSearchItem(item.id, item);
      notifyListeners();
    }
  }

  Future<void> _fetchPostChangeSearch(String query) async {
    final listPost = await PostService.instance.searchPost(query, 2);
    if (listPost.isNotEmpty) {
      for (var element in listPost) {
        final searchItem = SearchItem(
          name: element.title ?? element.profileName,
          id: element.id,
          title: element.content.text,
          imageUrl: element.avatarUrl,
          type: SearchType.post,
        );
        recommendedPostSearch.add(searchItem);
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
          title: element.tagName,
          imageUrl: element.avatarUrl,
          type: SearchType.squad,
        );
        recommendedSquadSearch.add(searchItem);
      }
    }
  }

  Future<void> _fetchUserChangeSearch(String query) async {
    final listUser = await UserService.instance.searchUser(query, 2);
    if (listUser.isNotEmpty) {
      for (var element in listUser) {
        final searchItem = SearchItem(
            name: '${element.firstName} ${element.lastName}',
            id: element.id,
            imageUrl: element.avatarUrl,
            type: SearchType.profile,
            title: element.email);
        recommendedUserSearch.add(searchItem);
      }
    }
  }

  Future<PostModelResponse> getPostById(String postId) async {
    final res = await PostService.instance.getPostDetailById(postId);
    return res;
  }
}
