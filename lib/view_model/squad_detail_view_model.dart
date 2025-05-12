import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/main.dart';
import 'package:untitled/model/admin_squad.dart';
import 'package:untitled/model/user_role.dart';
import 'package:untitled/service/post_service.dart';

import '../model/comment_response.dart';
import '../model/post_model_response.dart';
import '../model/profile_response.dart';
import '../model/squad_response.dart';
import '../service/squad_service.dart';
import '../service/user_service.dart';

class SquadDetailViewModel extends ChangeNotifier {
  final String tagName;
  late SquadResponse squad;
  bool isLoading = true;
  String? error;
  final Map<String, String> adminAvatars = {};
  String? currentUserId;
  bool isAdmin = false;
  bool isLoadingPost = false;

  bool get hasMore => hasMorePosts;
  List<AdminSquad> membersOfficial = [];
  List<AdminSquad> membersPending = [];

  SquadDetailViewModel(this.tagName) {
    scrollController.addListener(_scrollListener);
    initialize();
  }

  initialize() async {
    isLoading = true;
    notifyListeners();
    await _loadCurrentUser();
    await _fetchSquad();
    if (isAdmin) {
      Future.wait([
        _fetchOfficialMember(),
        _fetchPendingMember(),
      ]);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    final currentUser = await LocalStorage.instance.userId;
    currentUserId = currentUser;
  }

  final List<PostModelResponse> posts = [];
  int page = 0;
  final int size = 10;
  bool hasMorePosts = true;
  final ScrollController scrollController = ScrollController();

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMorePosts();
    }
  }

  Future<void> _fetchSquad() async {
    try {
      notifyListeners();

      final result = await SquadService.instance.getSquadInfo(tagName);
      squad = result;
      isAdmin =
          squad.adminList.any((admin) => admin.profileId == currentUserId);
      for (var admin in result.adminList) {
        try {
          final ProfileResponse profile =
              await UserService.instance.getProfile(admin.profileId);
          adminAvatars[admin.profileId] = profile.avatarUrl ?? '';
        } catch (e) {
          adminAvatars[admin.profileId] = '';
        }
      }

      await _fetchPosts();
    } catch (e) {
      error = e.toString();
    } finally {
      await _updateAvatarAdmin();
      notifyListeners();
    }
  }

  Future<void> _fetchOfficialMember() async {
    try {
      final result = await SquadService.instance.getOfficialMembers(tagName);
      membersOfficial = result.where((member) {
        return member.role == UserRole.member.label;
      }).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      await _updateAvatarOfficialMember();
      notifyListeners();
    }
  }

  Future<void> _fetchPendingMember() async {
    try {
      var result = await SquadService.instance.getPendingMembers(tagName);
      membersPending = result.where((member) {
        return member.joinStatus == UserRole.pending.label;
      }).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      await _updateAvatarPendingMember();
      notifyListeners();
    }
  }

  Future<void> joinSquad() async {
    final currentContext = navigatorKey.currentContext!;

    try {
      showDialog(
        context: currentContext,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final response = await UserService.instance.sendRequest(tagName);
      if (!currentContext.mounted) return;

      Navigator.of(currentContext).pop();

      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
            content: Text(response.message ?? 'Request sent successfully')),
      );

      updateSquadJoinStatus(UserRole.pending.label);
    } catch (error) {
      if (!currentContext.mounted) return;

      try {
        Navigator.of(currentContext).pop();
      } catch (_) {}

      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text('Failed to send request: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchPosts() async {
    try {
      if (isLoadingPost || !hasMorePosts) return;

      isLoadingPost = true;
      notifyListeners();

      final newPosts =
          await PostService.instance.getSquadPosts(tagName, size, page);
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
      isLoadingPost = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (!isLoadingPost && hasMorePosts) {
      await _fetchPosts();
    }
  }

  Future<void> _updateAvatarAdmin() async {
    for (var admin in squad.adminList) {
      try {
        final ProfileResponse profile =
            await UserService.instance.getProfile(admin.profileId);
        admin.avatarUrl = profile.avatarUrl ?? '';
      } catch (e) {
        admin.avatarUrl = AppConstants.urlImageDefault;
      }
    }
    notifyListeners();
  }

  Future<void> _updateAvatarPendingMember() async {
    for (var member in membersPending) {
      try {
        final ProfileResponse profile =
            await UserService.instance.getProfile(member.profileId);
        member.avatarUrl = profile.avatarUrl ?? '';
      } catch (e) {
        member.avatarUrl = AppConstants.urlImageDefault;
      }
    }
    notifyListeners();
  }

  Future<void> _updateAvatarOfficialMember() async {
    for (var member in membersOfficial) {
      try {
        final ProfileResponse profile =
            await UserService.instance.getProfile(member.profileId);
        member.avatarUrl = profile.avatarUrl ?? '';
      } catch (e) {
        member.avatarUrl = AppConstants.urlImageDefault;
      }
    }
    notifyListeners();
  }

  Future<void> updateSquadJoinStatus(String newStatus) async {
    squad = SquadResponse(
      id: squad.id,
      name: squad.name,
      avatarUrl: squad.avatarUrl,
      privacy: squad.privacy,
      description: squad.description,
      tagName: squad.tagName,
      setting: squad.setting,
      totalPosts: squad.totalPosts,
      totalMembers: squad.totalMembers,
      adminList: squad.adminList,
      canBeEdited: squad.canBeEdited,
      joinStatus: newStatus,
      createdAt: squad.createdAt,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<List<CommentResponse>> getComment(PostModelResponse post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }

  Future<void> acceptPendingUser(AdminSquad user) async {
    final response = await SquadService.instance
        .approveSquadMember(squad.tagName, user.profileId);
    if (response) {
      membersPending
          .removeWhere((member) => member.profileId == user.profileId);
      membersOfficial.add(user);
      notifyListeners();
    }
  }

  Future<void> rejectPendingUser(AdminSquad user) async {
    final response = await SquadService.instance
        .rejectSquadMember(squad.tagName, user.profileId);
    if (response) {
      membersPending
          .removeWhere((member) => member.profileId == user.profileId);
      notifyListeners();
    }
  }
}
