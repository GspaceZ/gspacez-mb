import 'package:flutter/cupertino.dart';
import '../model/post_model_response.dart';
import '../service/post_service.dart';

class TagViewModel extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  List<String> searchResults = [];
  List<PostModelResponse> posts = [];
  List<String> popularsTags = [];

  String _currentTag = '';
  int _page = 0;
  final int _size = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _loadingPosts = false;

  TagViewModel() {
    scrollController.addListener(_onScroll);
    _init();
  }

  Future<void> _init() async {
    await fetchPopularTags();
  }

  bool get isLoading => _isLoading;

  Future<void> fetchPopularTags() async {
    _isLoading = true;
    try {
      popularsTags = await PostService.instance.getPopularsTags();
    } catch (e) {
      popularsTags = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchTags(String query) async {
    _currentTag = query;
    if (query.isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await PostService.instance.searchTags(query);
      searchResults = response;
    } catch (e) {
      searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectTag(String tag) async {
    _currentTag = tag;
    _page = 0;
    _hasMore = true;
    posts.clear();

    searchController.text = tag;

    searchResults = [];
    notifyListeners();

    await fetchPostsByTag();
  }

  Future<void> fetchPostsByTag() async {
    if (_loadingPosts || !_hasMore || _currentTag.isEmpty) return;
    _loadingPosts = true;
    notifyListeners();

    try {
      final newPosts = await PostService.instance.getPostsByHashtag(_currentTag, _size, _page);
      posts.addAll(newPosts);
      if (newPosts.length < _size) {
        _hasMore = false;
      } else {
        _page++;
      }
    } catch (e) {
      // handle error if needed
    } finally {
      _loadingPosts = false;
      notifyListeners();
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchPostsByTag();
    }
  }

  Future<void> refreshPosts() async {
    _page = 0;
    _hasMore = true;
    posts.clear();
    await fetchPostsByTag();
  }

  String get currentTag => _currentTag;

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
