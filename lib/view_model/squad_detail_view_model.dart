import 'package:flutter/material.dart';
import 'package:untitled/service/post_service.dart';
import '../model/comment_response.dart';
import '../model/post_model_response.dart';
import '../model/profile_response.dart';
import '../model/squad_response.dart';
import '../service/squad_service.dart';
import '../service/user_service.dart';

class SquadDetailViewModel extends ChangeNotifier {
  SquadResponse? squad;
  bool isLoadingSquad = true;
  bool isLoadingAvatars = true;
  String? error;
  final Map<String, String> adminAvatars = {};

  final List<PostModelResponse> posts = [];
  bool isLoadingPosts = false;
  int page = 0;
  final int size = 10;
  bool hasMorePosts = true;
  final ScrollController scrollController = ScrollController();

  SquadDetailViewModel() {
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMorePosts();
    }
  }

  Future<void> fetchSquad(String tagName) async {
    try {
      isLoadingSquad = true;
      isLoadingAvatars = true;
      notifyListeners();

      final result = await SquadService.instance.getSquadInfo(tagName);
      squad = result;

      for (var admin in result.adminList) {
        try {
          final ProfileResponse profile = await UserService.instance.getProfile(admin.profileId);
          adminAvatars[admin.profileId] = profile.avatarUrl ?? '';
        } catch (e) {
          adminAvatars[admin.profileId] = '';
        }
      }

      await fetchPosts(tagName);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingSquad = false;
      isLoadingAvatars = false;
      notifyListeners();
    }
  }

  Future<void> fetchPosts(String tagName) async {
    try {
      if (isLoadingPosts || !hasMorePosts) return;

      isLoadingPosts = true;
      notifyListeners();

      final newPosts = await PostService.instance.getSquadPosts(tagName, size, page);
      if (newPosts.isNotEmpty) {
        posts.addAll(newPosts);
        page++;
      }

      if (newPosts.length < size) {
        hasMorePosts = false;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingPosts = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (squad != null && !isLoadingPosts && hasMorePosts) {
      await fetchPosts(squad!.tagName);
    }
  }

  Future<void> updateSquadJoinStatus(String newStatus) async {
    if (squad != null) {
      squad = SquadResponse(
        id: squad!.id,
        name: squad!.name,
        avatarUrl: squad!.avatarUrl,
        privacy: squad!.privacy,
        description: squad!.description,
        tagName: squad!.tagName,
        setting: squad!.setting,
        totalPosts: squad!.totalPosts,
        totalMembers: squad!.totalMembers,
        adminList: squad!.adminList,
        canBeEdited: squad!.canBeEdited,
        joinStatus: newStatus,
        createdAt: squad!.createdAt,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool get isLoading => isLoadingPosts;
  bool get hasMore => hasMorePosts;

  Future<List<CommentResponse>> getComment(PostModelResponse post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }
}
