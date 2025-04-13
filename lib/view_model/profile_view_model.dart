import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/model/squad_model.dart';
import 'package:untitled/service/post_service.dart';
import 'package:untitled/service/squad_service.dart';

import '../service/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  String profileId = '';
  String avatarUrl = '';
  String userName = '';
  String dateOfBirth = '';
  String address = '';

  final List<PostModelResponse> listProfilePosts = [];
  final List<PostModelResponse> listLikedPosts = [];
  final List<SquadModel> involvedSquads = [];

  int _pageNum = 0;
  final int _pageSize = 5;
  bool _isLoading = false;
  bool _hasMoreProfilePosts = true;
  bool _hasMoreLikedPosts = true;
  final ScrollController scrollController = ScrollController();

  final List<SquadModel> otherUser = [];

  int _currentTabIndex = 0;  // defaul tab: posts

  void updateCurrentTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  ProfileViewModel() {
    scrollController.addListener(_onScroll);
    _init();
  }

  _init() async {
    await _getUserInfo();
    await _fetchData();
  }

  _getUserInfo() async {
    final profile = await UserService.instance.getProfile();
    profileId = profile.id;
    avatarUrl = profile.avatarUrl ?? AppConstants.urlImageDefault;
    userName = "${profile.firstName} ${profile.lastName}".trim();
    dateOfBirth = profile.dob ?? '';
    address = profile.address ?? '';
    notifyListeners();
  }

  _fetchData() async {
    final List<SquadModel> joinedSquads = await SquadService.instance.getJoinedSquads(profileId);
    involvedSquads.clear();
    involvedSquads.addAll(joinedSquads);

    await fetchProfilePosts(isRefresh: true);
    await fetchLikedPosts(isRefresh: true);
  }

  Future<void> fetchProfilePosts({bool isRefresh = false}) async {
    if (_isLoading || !_hasMoreProfilePosts) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (isRefresh) {
        _pageNum = 0;
        listProfilePosts.clear();
        _hasMoreProfilePosts = true;
      }

      final response = await UserService.instance
          .getPostsByProfile(profileId, _pageNum, _pageSize);

      if (response.isNotEmpty) {
        listProfilePosts.addAll(response);
        _pageNum++;
      }

      if (response.length < _pageSize) {
        _hasMoreProfilePosts = false;
      }
    } catch (e) {
      throw Exception("Failed to fetch profile posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLikedPosts({bool isRefresh = false}) async {
    if (_isLoading || !_hasMoreLikedPosts) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (isRefresh) {
        _pageNum = 0;
        listLikedPosts.clear();
        _hasMoreLikedPosts = true;
      }

      final response = await UserService.instance
          .getLikedPostsByProfile(profileId, _pageSize, _pageNum);

      if (response.isNotEmpty) {
        listLikedPosts.addAll(response);
        _pageNum++;
      }

      if (response.length < _pageSize) {
        _hasMoreLikedPosts = false;
      }
    } catch (e) {
      throw Exception("Failed to fetch liked posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (_currentTabIndex == 0) {
        fetchProfilePosts();
      } else if (_currentTabIndex == 1) {
        fetchLikedPosts();
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
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
