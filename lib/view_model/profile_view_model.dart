import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/model/profile_response.dart';
import 'package:untitled/model/squad_model.dart';
import 'package:untitled/service/post_service.dart';
import 'package:untitled/service/squad_service.dart';

import '../service/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  String? _profileTag;
  String profileId = '';
  String avatarUrl = '';
  String userName = '';
  String dateOfBirth = '';
  String country = '';
  String profileTag = '';
  String totalPost = "--";
  String totalSquad = "--";
  String totalUpvote = "--";
  List<SocialMedia> socialMedias = [];
  final List<PostModelResponse> listProfilePosts = [];
  final List<PostModelResponse> listLikedPosts = [];
  final List<SquadModel> involvedSquads = [];

  int _postsPageNum = 0;
  int _likedPostsPageNum = 0;
  final int _pageSize = 5;
  bool _isLoading = true;
  bool _hasMoreProfilePosts = true;
  bool _hasMoreLikedPosts = true;
  bool _isLoadingMorePosts = false;
  bool _isLoadingMoreLikedPosts = false;
  final ScrollController mainScrollController = ScrollController();
  final ScrollController postsScrollController = ScrollController();

  int _currentTabIndex = 0;

  void updateCurrentTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  ProfileViewModel({String? profileTag}) {
    _profileTag = profileTag;
    postsScrollController.addListener(_onPostsScroll);
    _init();
  }

  Future<void> refreshAll() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _getUserInfo();
      if (profileId.isNotEmpty && profileTag.isNotEmpty) {
        await _fetchData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _init() async {
    try {
      await _getUserInfo();
      if (profileId.isNotEmpty && profileTag.isNotEmpty) {
        await _fetchData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getUserInfo() async {
    try {
      final profile = _profileTag == null
          ? await UserService.instance.getMe()
          : await UserService.instance.getProfile(_profileTag!);

      profileId = profile.id;
      profileTag = profile.profileTag;
      avatarUrl = profile.avatarUrl ?? AppConstants.urlImageDefault;
      userName = "${profile.firstName} ${profile.lastName}".trim();
      dateOfBirth = profile.dob ?? '';
      country = profile.country ?? '';
      socialMedias = profile.socialMedias;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }

  Future<void> _fetchData() async {
    if (profileId.isEmpty || profileTag.isEmpty) {
      debugPrint('Cannot fetch data: profileId or profileTag is empty');
      return;
    }

    try {
      // Fetch squads
      final List<SquadModel> joinedSquads =
          await SquadService.instance.getJoinedSquads(profileTag);
      involvedSquads.clear();
      totalSquad = joinedSquads.length.toString();
      involvedSquads.addAll(joinedSquads);

      // Reset paging data
      _postsPageNum = 0;
      _likedPostsPageNum = 0;
      _hasMoreProfilePosts = true;
      _hasMoreLikedPosts = true;
      listProfilePosts.clear();
      listLikedPosts.clear();

      // Fetch initial posts and liked posts
      await Future.wait([
        _fetchInitialProfilePosts(),
        _fetchInitialLikedPosts(),
      ]);
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> _fetchInitialProfilePosts() async {
    try {
      final response = await UserService.instance
          .getPostsByProfile(profileTag, 0, _pageSize);
      totalPost = response.item2.toString();

      if (response.item1.isNotEmpty) {
        listProfilePosts.addAll(response.item1);
        _postsPageNum = 1;
      }

      if (response.item1.length < _pageSize) {
        _hasMoreProfilePosts = false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching initial profile posts: $e');
    }
  }

  Future<void> _fetchInitialLikedPosts() async {
    try {
      final response = await UserService.instance
          .getLikedPostsByProfile(profileId, _pageSize, 0);
      totalUpvote = response.item2.toString();

      if (response.item1.isNotEmpty) {
        listLikedPosts.addAll(response.item1);
        _likedPostsPageNum = 1;
      }

      if (response.item1.length < _pageSize) {
        _hasMoreLikedPosts = false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching initial liked posts: $e');
    }
  }

  Future<void> fetchProfilePosts({bool isRefresh = false}) async {
    if (_isLoadingMorePosts || !_hasMoreProfilePosts || profileTag.isEmpty) return;

    _isLoadingMorePosts = true;
    if (isRefresh) {
      _isLoading = true;
      _postsPageNum = 0;
      listProfilePosts.clear();
      _hasMoreProfilePosts = true;
    }
    notifyListeners();

    try {
      final response = await UserService.instance
          .getPostsByProfile(profileTag, _postsPageNum, _pageSize);
      totalPost = response.item2.toString();

      if (response.item1.isNotEmpty) {
        listProfilePosts.addAll(response.item1);
        _postsPageNum++;
      }

      if (response.item1.length < _pageSize) {
        _hasMoreProfilePosts = false;
      }
    } catch (e) {
      debugPrint("Failed to fetch profile posts: $e");
    } finally {
      _isLoadingMorePosts = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLikedPosts({bool isRefresh = false}) async {
    if (_isLoadingMoreLikedPosts || !_hasMoreLikedPosts || profileId.isEmpty) return;

    _isLoadingMoreLikedPosts = true;
    if (isRefresh) {
      _isLoading = true;
      _likedPostsPageNum = 0;
      listLikedPosts.clear();
      _hasMoreLikedPosts = true;
    }
    notifyListeners();

    try {
      final response = await UserService.instance
          .getLikedPostsByProfile(profileId, _pageSize, _likedPostsPageNum);
      totalUpvote = response.item2.toString();

      if (response.item1.isNotEmpty) {
        listLikedPosts.addAll(response.item1);
        _likedPostsPageNum++;
      }

      if (response.item1.length < _pageSize) {
        _hasMoreLikedPosts = false;
      }
    } catch (e) {
      debugPrint("Failed to fetch liked posts: $e");
    } finally {
      _isLoadingMoreLikedPosts = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onPostsScroll() {
    if (postsScrollController.position.pixels >=
        postsScrollController.position.maxScrollExtent - 200) {
      if (_currentTabIndex == 1) {
        // Posts tab
        fetchProfilePosts();
      } else if (_currentTabIndex == 2) {
        // Upvoted tab
        fetchLikedPosts();
      }
    }
  }

  @override
  void dispose() {
    mainScrollController.dispose();
    postsScrollController.dispose();
    super.dispose();
  }

  bool get isLoading => _isLoading;
  bool get hasMoreProfilePosts => _hasMoreProfilePosts;
  bool get hasMoreLikedPosts => _hasMoreLikedPosts;

  Future<List<CommentResponse>> getComment(PostModelResponse post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }
}
