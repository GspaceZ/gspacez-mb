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
  List<SearchItem> searchResults = [];
  List<SearchItem> searchHistory = [];
  List<SearchItem> searchSquad = [];
  List<SearchItem> searchPost = [];
  List<SearchItem> recommendedUserSearch = [];
  List<SearchItem> recommendedSquadSearch = [];
  List<SearchItem> recommendedPostSearch = [];
  List<PostModelResponse> listPostModel = [];
  List<SquadResponse> listSquadModel = [];
  List<SearchItem> postChangeSearch = [];
  List<SearchItem> squadChangeSearch = [];
  List<SearchItem> userChangeSearch = [];
  final postController = ScrollController();
  final squadController = ScrollController();
  final userController = ScrollController();
  bool hasMorePost = true;
  bool hasMoreSquad = true;
  bool hasMoreUser = true;
  int pagePost = 0;
  int pageSquad = 0;
  int pageUser = 0;

  SearchViewModel() {
    _init();
    _setupScrollListeners();
    _setupSearchListener();
  }

  Future<void> _init() async {
    searchHistory = SearchItemService.getAllSearchItems();
    notifyListeners();
  }

  void _setupScrollListeners() {
    postController.addListener(() {
      if (postController.position.pixels >=
          postController.position.maxScrollExtent - 100) {
        if (hasMorePost) {
          pagePost++;
          searchPostFromApi(searchController.text);
        }
      }
    });

    squadController.addListener(() {
      if (squadController.position.pixels >=
          squadController.position.maxScrollExtent - 100) {
        if (hasMoreSquad) {
          pageSquad++;
          searchSquadFromApi(searchController.text);
        }
      }
    });

    userController.addListener(() {
      if (userController.position.pixels >=
          userController.position.maxScrollExtent - 100) {
        if (hasMoreUser) {
          pageUser++;
          searchProfile(searchController.text);
        }
      }
    });
  }

  void _setupSearchListener() {
    searchController.addListener(() {
      final query = searchController.text;
      if (query.isNotEmpty) {
        onSearchChanged(query);
      } else {
        clearSearch();
      }
    });
  }

  Future<void> searchAll(String query) async {
    if (query.isEmpty) return;
    _clearAllSearchData();
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

  Future<void> searchProfile(String query) async {
    final listUser = await UserService.instance.searchUser(query, 20, pageUser);
    if (listUser.isEmpty) return;
    final newItems = listUser.map((element) => SearchItem(
          name: '${element.firstName} ${element.lastName}',
          id: element.id,
          imageUrl: element.avatarUrl,
          type: SearchType.profile,
          title: element.email,
        ));
    searchResults.addAll(newItems);
    notifyListeners();
  }

  Future<void> searchPostFromApi(String query) async {
    final result = await PostService.instance.searchPost(query, 20, pagePost);
    if (result.isEmpty) {
      hasMorePost = false;
      return;
    }
    listPostModel.addAll(result);
    final newItems = result.map((element) => SearchItem(
          name: element.title ?? "",
          id: element.id,
          imageUrl: element.previewImage,
          title: element.content.text,
          type: SearchType.post,
        ));
    searchPost.addAll(newItems);
    notifyListeners();
  }

  Future<void> searchSquadFromApi(String query) async {
    final result =
        await SquadService.instance.searchSquad(query, 20, pageSquad);
    if (result.isEmpty) {
      hasMoreSquad = false;
      return;
    }
    listSquadModel.addAll(result);
    final newItems = result.map((element) => SearchItem(
          name: element.name,
          id: element.tagName,
          imageUrl: element.avatarUrl,
          type: SearchType.squad,
          title: element.tagName,
        ));
    searchSquad.addAll(newItems);
    notifyListeners();
  }

  Future<void> onSearchChanged(String query) async {
    if (query.isEmpty) {
      clearSearch();
      return;
    }
    if (!isSearch) {
      await onRecommendedSearchChanged(query);
    } else {
      _clearAllSearchData();
      notifyListeners();
      await Future.wait([
        searchProfile(query),
        searchSquadFromApi(query),
        searchPostFromApi(query),
      ]);
      notifyListeners();
    }
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
    isSearch = false;
    _clearAllSearchData();
    notifyListeners();
  }

  void _clearAllSearchData() {
    recommendedUserSearch.clear();
    recommendedSquadSearch.clear();
    recommendedPostSearch.clear();
    searchResults.clear();
    searchPost.clear();
    searchSquad.clear();
    listPostModel.clear();
    listSquadModel.clear();
    pageUser = 0;
    pagePost = 0;
    pageSquad = 0;
    hasMoreUser = true;
    hasMorePost = true;
    hasMoreSquad = true;
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
    final listPost = await PostService.instance.searchPost(query, 2, 0);
    final newItems = listPost.map((element) => SearchItem(
          name: element.title ?? element.profileName,
          id: element.id,
          title: element.content.text,
          imageUrl: element.avatarUrl,
          type: SearchType.post,
        ));
    recommendedPostSearch.addAll(newItems);
  }

  Future<void> _fetchSquadChangeSearch(String query) async {
    final listSquad = await SquadService.instance.searchSquad(query, 2, 0);
    final newItems = listSquad.map((element) => SearchItem(
          name: element.name,
          id: element.tagName,
          title: element.tagName,
          imageUrl: element.avatarUrl,
          type: SearchType.squad,
        ));
    recommendedSquadSearch.addAll(newItems);
  }

  Future<void> _fetchUserChangeSearch(String query) async {
    final listUser = await UserService.instance.searchUser(query, 2, 0);
    final newItems = listUser.map((element) => SearchItem(
          name: '${element.firstName} ${element.lastName}',
          id: element.id,
          imageUrl: element.avatarUrl,
          type: SearchType.profile,
          title: element.email,
        ));
    recommendedUserSearch.addAll(newItems);
  }

  Future<PostModelResponse> getPostById(String postId) async {
    return await PostService.instance.getPostDetailById(postId);
  }
}
