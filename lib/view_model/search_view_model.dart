import 'package:flutter/material.dart';
import 'package:untitled/data/local/search_item_service.dart';
import 'package:untitled/model/search_item.dart';
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
      Future.wait([
        searchProfile(query),
        searchSquadFromApi(query),
        // searchPostFromApi(query), // Uncomment when post search is implemented
      ]);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProfile(String query) async {
    if (searchController.text.isNotEmpty) {
      final listUser = await UserService.instance.searchUser(query);
      if (listUser.isNotEmpty) {
        for (var element in listUser) {
          final searchItem = SearchItem(
            name: '${element.firstName} ${element.lastName}',
            id: element.id,
            imageUrl: element.avatarUrl,
            type: SearchType.profile,
          );
          searchResults.add(searchItem);
        }
      }
    }
  }

  Future<void> searchSquadFromApi(String query) async {
    if (searchController.text.isNotEmpty) {
      notifyListeners();
      final listSquad = await SquadService.instance.searchSquad(query);
      if (listSquad.isNotEmpty) {
        for (var element in listSquad) {
          final searchItem = SearchItem(
            name: element.name,
            id: element.id,
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
      searchHistory = searchHistory
          .where((result) =>
              result.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (query.length == 1) {
        onRecommendedSearchChanged(query);
      } else {
        recommendedSearch = recommendedSearch
            .where((result) =>
                result.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } else {
      clearSearch();
    }
    notifyListeners();
  }

  Future<void> onRecommendedSearchChanged(String query) async {
    recommendedSearch.clear();
    // final listSquad = await SquadService.instance.searchSquad(query);
    // if (listSquad.isNotEmpty) {
    //   for (var element in listSquad) {
    //     final searchItem = SearchItem(
    //       name: element.name,
    //       id: element.id,
    //       imageUrl: element.avatarUrl,
    //       type: SearchType.squad,
    //     );
    //     recommendedSearch.add(searchItem);
    //   }
    // }
    final listUser = await UserService.instance.searchUser(query);
    if (listUser.isNotEmpty) {
      for (var element in listUser) {
        final searchItem = SearchItem(
          name: '${element.firstName} ${element.lastName}',
          id: element.id,
          imageUrl: element.avatarUrl,
          type: SearchType.profile,
        );
        recommendedSearch.add(searchItem);
      }
    }
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
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
}
