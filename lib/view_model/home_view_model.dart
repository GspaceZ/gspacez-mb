import 'package:flutter/widgets.dart';
import 'package:untitled/model/content_post_model.dart';
import 'package:untitled/model/post_model_response.dart';
import 'package:untitled/service/post_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    fetchPost();
  }

  final List<PostModel> posts = [];

  Future<void> fetchPost() async {
    final response = await PostService.instance.getNewFeed();
    posts.addAll(response);
    notifyListeners();
  }

  Future<void> createPost(ContentPostModel contentPost) async {
    // create post from api
    await Future.delayed(const Duration(seconds: 1)); // delay 1s
    final postModel = PostModel(
      id: '1',
      type: 'text',
      privacy: 'public',
      content: contentPost,
      profileId: '1',
      profileName: 'profileName',
      avatarUrl:
          'https://res.cloudinary.com/dszkt92jr/image/upload/v1719943637/vcbhui3dxeusphkgvycg.png',
      hashTags: ['hashTag'],
      trendingPoint: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      hidden: false,
    );
    posts.insert(0, postModel);
    notifyListeners();
  }
}
