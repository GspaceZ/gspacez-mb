import 'package:flutter/cupertino.dart';
import '../model/discussion_response.dart';
import '../service/post_service.dart';

class DiscussionViewModel extends ChangeNotifier {
  DiscussionViewModel() {
    scrollController.addListener(_onScroll);
    fetchDiscussions();
  }

  final List<DiscussionResponse> discussions = [];
  final ScrollController scrollController = ScrollController();
  int _page = 0;
  final int _size = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  set searchQuery(String query) {
    _searchQuery = query;
    fetchDiscussions(isRefresh: true);
    notifyListeners();
  }

  Future<void> fetchDiscussions({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (isRefresh) {
        _page = 0;
        discussions.clear();
        _hasMore = true;
      }

      final result = await PostService.instance
          .searchDiscussions(_searchQuery, _size, _page);

      if (result.isNotEmpty) {
        discussions.addAll(result);
        _page++;
      }

      if (result.length < _size) {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('Fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchDiscussions();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
}
