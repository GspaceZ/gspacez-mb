import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/comment_response.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/model/squad_model.dart';
import 'package:untitled/service/post_service.dart';

class ProfileViewModel extends ChangeNotifier {
  String urlAvatar = AppConstants.urlImageDefault;
  String userName = '';
  String dateOfBirth = '';
  String location = '';

  final List<PostModelResponse> listMyPost = [];
  final List<PostModelResponse> listLikePost = [];
  final List<SquadModel> involvedSquads = [];

  /// TODO: mock other user
  final List<SquadModel> otherUser = [];

  ProfileViewModel() {
    _init();
  }

  _init() async {
    _getUserInfo();
    _fetchData();
  }

  _getUserInfo() async {
    urlAvatar = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    userName = await LocalStorage.instance.userName ?? '';
    dateOfBirth = '12/12/2000';
    location = await LocalStorage.instance.nation ?? '';
    notifyListeners();
  }

  _fetchData() async {
    /// TODO: mock data
    // mock involvedSquads
    involvedSquads.addAll([
      SquadModel(name: 'Flutter', urlImage: AppConstants.urlImageDefault),
      SquadModel(
        name: 'Kotlin',
        urlImage: AppConstants.urlImageDefault,
      ),
      SquadModel(
        name: 'Swift',
        urlImage: AppConstants.urlImageDefault,
      ),
    ]);
    // mock other user
    otherUser.addAll([
      SquadModel(name: 'Bùi', urlImage: AppConstants.urlImageDefault),
      SquadModel(
        name: 'Nguyễn',
        urlImage: AppConstants.urlImageDefault,
      ),
      SquadModel(
        name: 'Anh',
        urlImage: AppConstants.urlImageDefault,
      ),
    ]);

    // mock listMyPost, list Like post
    final response = await PostService.instance.getNewFeed(1, 20);
    if (response.isNotEmpty) {
      listMyPost.addAll(response);
      listLikePost.addAll(response);
    }
    notifyListeners();
  }

  Future<List<CommentResponse>> getComment(PostModelResponse post) async {
    final response = await PostService.instance.getCommentById(post.id);
    return response;
  }
}
